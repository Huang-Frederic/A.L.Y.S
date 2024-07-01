import json
import os
import re
import time
from datetime import datetime
from pathlib import Path

from alive_progress import alive_bar
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed

from .base_parser import BaseParser
from database.database_client import DatabaseClient
from models.author_model import Author
from models.book_model import Book, BookStatus, BookType
from models.chapter_model import Chapter
from models.genre_model import Genre
from models.image_model import Image
from utils.fetch import fetch_html
from utils.logging import Logger

class MangaseeParser(BaseParser):
    def __init__(self, url, book_url, chapter_url, logger: Logger, database_client: DatabaseClient):
        self.logger = logger
        self.database_client = database_client
        self.url = url
        self.book_url = book_url
        self.chapter_url = chapter_url

    def parse(self):
        self.logger.log("Initializing A.L.Y.S system...", log_level="STATE")
        start_time = datetime.now()
        self.logger.log(f"A.L.Y.S activated at: {start_time.strftime('%Y-%m-%d %H:%M:%S')}", log_level="STATE")

        self.logger.log(f"Commencing data extraction from: {self.url}", log_level="STATE")
        html = fetch_html(self.url)
        if not html:
            self.logger.log("Failed to fetch HTML content.", log_level="ERROR")
            return

        # Parse the JSON string format
        start_pattern = "vm.Directory = "
        end_pattern = "}];"

        start_index = html.find(start_pattern)
        if start_index == -1:
            self.logger.log("Start pattern ([vm.Directory =]) not found.", log_level="ERROR")
            return
        start_index += len(start_pattern)

        end_index = html.find(end_pattern, start_index)
        if end_index == -1:
            self.logger.log("End pattern ([}];]) not found.", log_level="ERROR")
            return
        end_index += len(end_pattern)
        json_string = html[start_index:end_index].rstrip(";")

        # Turn into JSON format
        try:
            json_data = sorted(json.loads(json_string), key=lambda x: x.get('v', 0), reverse=True)
        except json.JSONDecodeError as e:
            self.logger.log(f"Error decoding JSON: {e}", log_level="ERROR")
            return

        self.logger.log(f"Found {len(json_data)} books.", log_level="SUCCESS")
        books = []
        for i, book in enumerate(json_data):
            if i < 3:
                self.logger.log(f"Processing book {i + 1} of {len(json_data)} : {book['i']}", log_level="INFO")
                book_html = fetch_html(self.book_url + book["i"])
                parsed_book = self.parseBook(book_html)
                if len(parsed_book.chapters) != 0:
                    books.append(parsed_book)

        self.logger.log(f"Completed processing {len(json_data)} books, {len(books)} to insert.", log_level="SUCCESS")
        end_time = datetime.now()
        self.logger.log(f"A.L.Y.S completed first task at: {end_time.strftime('%Y-%m-%d %H:%M:%S')}", log_level="STATE")
        self.logger.log(f"Total time active: {end_time - start_time}", log_level="STATE")
        
        return books

    def parseBook(self, book_html):
        soup = BeautifulSoup(book_html, "html.parser")

        # Extract cover URL
        cover_img = soup.find("img", class_="img-fluid bottom-5")
        cover_url = cover_img["src"] if cover_img else None

        # Extract title
        title_div = soup.find("div", class_="d-sm-none col-9 top-5 bottom-5")
        inner_div = title_div.find("div", class_="bottom-10") if title_div else None
        title = inner_div.get_text(strip=True) if inner_div else None

        # Find the <li> elements and extract more information
        extracted_list = soup.find_all("li", class_="list-group-item d-none d-md-block")
        # Initialize lists
        authors_list = []
        genres_list = []
        book_type = None
        release = None
        book_status = None
        # Loop to extract information
        for li in extracted_list:
            span_text = li.find("span", class_="mlabel").get_text(strip=True)
            a_tags = li.find_all("a")

            if "Author(s)" in span_text:
                for a_tag in a_tags:
                    author_name = a_tag.get_text(strip=True)
                    try:
                        first_name, last_name = author_name.split(" ", 1)
                    except:
                        first_name = author_name
                        last_name = ""
                    authors_list.append(Author(first_name, last_name))

            elif "Genre(s)" in span_text:
                for a_tag in a_tags:
                    genre_name = a_tag.get_text(strip=True)
                    genres_list.append(Genre(genre_name))

            elif "Type" in span_text:
                book_type = BookType(a_tags[0].get_text(strip=True))

            elif "Released" in span_text:
                release = a_tags[0].get_text(strip=True)

            elif "Status" in span_text:
                status_text = a_tags[0].get_text(strip=True).split(" ")[0]
                book_status = BookStatus(status_text)

        # Extract description
        description_div = soup.find("div", class_="top-5 Content")
        description = description_div.get_text(strip=True) if description_div else None

        # Create a Book object and populate its attributes
        book = Book(title, release, book_type, book_status, description, cover_url)
        book.add_authors(authors_list)
        book.add_genres(genres_list)

        # Extract Chapters
        return self.parseChapters(book, book_html)
    
    def process_single_chapter(self, book_html, chapter, book_title):
        chapter_number = (float(chapter["Chapter"]) % 100000) / 10
        chapter_release = chapter["Date"]
        chapter_obj = Chapter(chapter_number, chapter_release)

        # Find the pattern to match vm.IndexName assignment
        pattern = r'vm\.IndexName\s*=\s*"([^"]+)"'
        match = re.search(pattern, book_html)
        if match:
            index_name = match.group(1)

        # Parse the images
        self.parseImages(index_name, chapter_obj)
        return chapter_obj

    def parseChapters(self, book, book_html):
        # Parse the JSON string format
        start_pattern = "vm.Chapters = "
        end_pattern = "}];"

        start_index = book_html.find(start_pattern)
        if start_index == -1:
            self.logger.log("Start pattern ([vm.Chapters = ]) not found.", log_level="ERROR")
            return
        start_index += len(start_pattern)

        end_index = book_html.find(end_pattern, start_index)
        if end_index == -1:
            self.logger.log("End pattern ([ }]; ]) not found.", log_level="ERROR")
            return
        end_index += len(end_pattern)
        json_string = book_html[start_index:end_index].rstrip(";")

        # Turn into JSON format
        try:
            existing_chapters = self.database_client.get_book_chapters_from_title(book.title)
            data = json.loads(json_string)
            chapters_data = []
            if len(data) >= 500:
                self.logger.log(f"{book.title} has {len(data)} chapters, we decided to skip it", log_level="SUCCESS")
            if len(data) < 500:
                for chapter in data:
                    if ((float(chapter["Chapter"]) % 100000) / 10) not in existing_chapters:
                        chapters_data.append(chapter)
        except json.JSONDecodeError as e:
            self.logger.log(f"Error decoding JSON: {e}", log_level="ERROR")
            return

        self.logger.log(f"Found {len(chapters_data)} new chapters for : {book.title}", log_level="SUCCESS")
        if len(chapters_data) != 0:
            with alive_bar(len(chapters_data), title=f"Processing chapters for {book.title}", spinner="classic") as bar:
                with ThreadPoolExecutor(max_workers=4) as executor:
                    future_to_chapter = {executor.submit(self.process_single_chapter, book_html, chapter, book.title): chapter for chapter in chapters_data}
                    for future in as_completed(future_to_chapter):
                        chapter_obj = future.result()
                        book.add_chapter(chapter_obj)
                        bar()
                self.logger.log(f"Chapters for book {book.title} processed successfully.", log_level="SUCCESS")
        return book



    def parseImages(self, index_name, chapter):
        self.logger.log(f"Parsing images for chapter: {chapter.number}", log_level="INFO")
        
        # Fetch the chapter page
        fetched_html = fetch_html(
            self.chapter_url + index_name + "-chapter-" + str(chapter.number)
        )
        if not fetched_html:
            self.logger.log(f"Failed to fetch chapter HTML content.", log_level="ERROR")
            return
        chapter_html = BeautifulSoup(fetched_html, "html.parser")
        images_html = chapter_html.find_all("img", class_="img-fluid")

        self.logger.log(f"Found {len(images_html)} images.", log_level="DEBUG")
        for i, image in enumerate(images_html):
            chapter.add_image(Image(i, image["src"]))
