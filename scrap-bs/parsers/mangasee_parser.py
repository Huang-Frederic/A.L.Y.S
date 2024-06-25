import json
import os
import re
from pathlib import Path

from bs4 import BeautifulSoup
from models.author_model import Author
from models.book_model import Book, BookStatus, BookType
from models.chapter_model import Chapter
from models.image_model import Image
from models.genre_model import Genre
from utils.fetch import fetch_html

from .base_parser import BaseParser


class MangaseeParser(BaseParser):
    def __init__(self, url, book_url, chapter_url):
        self.url = url
        self.book_url = book_url
        self.chapter_url = chapter_url
        self.html = fetch_html(self.url)

        # self.save_html_to_file(self.html)
        self.parse(self.html)

    def parse(self, html):
        # Parse the JSON string format
        start_pattern = "vm.Directory = "
        end_pattern = "}];"

        start_index = html.find(start_pattern)
        if start_index == -1:
            print("Start pattern not found.")
            return
        start_index += len(start_pattern)

        end_index = html.find(end_pattern, start_index)
        if end_index == -1:
            print("End pattern not found.")
            return
        end_index += len(end_pattern)
        json_string = html[start_index:end_index].rstrip(";")

        # Turn into JSON format
        try:
            json_data = json.loads(json_string)
        except json.JSONDecodeError as e:
            print("Error decoding JSON:", e)

        # Get parsed books as Book objects
        books = []
        i = 0
        for book in json_data:
            # if i == 5:
            #     break
            # book_html = fetch_html(self.book_url + book["i"])
            # books.append(self.parseBook(book_html))
            # i = i + 1
            if book["i"] == "DRCL-midnight-children":
                book_html = fetch_html(self.book_url + book["i"])
                books.append(self.parseBook(book_html))
            i = i + 1

        for book in books:
            print(book)

    def parseBook(self, book_html):
        soup = BeautifulSoup(book_html, "html.parser")

        # Extract cover URL
        cover_img = soup.find("img", class_="img-fluid bottom-5")
        cover_url = cover_img["src"] if cover_img else None

        # Extract title
        title_div = soup.find("div", class_="d-sm-none col-9 top-5 bottom-5")
        inner_div = title_div.find("div", class_="bottom-10") if title_div else None
        title = inner_div.get_text(strip=True) if inner_div else None

        # Find the <li> elements and extract more informations
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

        return self.parseChapters(book, book_html)

    def parseChapters(self, book, book_html):
        # Extract Chapters
        # Parse the JSON string format
        start_pattern = "vm.Chapters = "
        end_pattern = "}];"

        start_index = book_html.find(start_pattern)
        if start_index == -1:
            print("Start pattern not found.")
            return
        start_index += len(start_pattern)

        end_index = book_html.find(end_pattern, start_index)
        if end_index == -1:
            print("End pattern not found.")
            return
        end_index += len(end_pattern)
        json_string = book_html[start_index:end_index].rstrip(";")

        # Turn into JSON format
        try:
            chapters_data = json.loads(json_string)
        except json.JSONDecodeError as e:
            print("Error decoding JSON:", e)

        # Get parsed chapters as Chapter objects
        for chapter in chapters_data:
            chapter_number = ((float(chapter["Chapter"]) % 100000) / 10)
            chapter_release = chapter["Date"]
            chapter = Chapter(chapter_number, chapter_release)
            book.add_chapter(chapter)


            # Find the pattern to match vm.IndexName assignment
            pattern = r'vm\.IndexName\s*=\s*"([^"]+)"'
            match = re.search(pattern, book_html)
            if match:
                index_name = match.group(1)
            self.parseImages(index_name, chapter)

        return book

    def parseImages(self, index_name, chapter):
        fetched_html = fetch_html(self.chapter_url + index_name + "-chapter-" + str(chapter.number))
        chapter_html = BeautifulSoup(fetched_html, "html.parser")
        images_html = chapter_html.find_all("img", class_="img-fluid")

        for i, image in enumerate(images_html):
            chapter.add_image(Image(i, image["src"]))


