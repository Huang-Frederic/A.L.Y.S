import json
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime

from alive_progress import alive_bar
from bs4 import BeautifulSoup
from database.database_client import DatabaseClient
from models.author_model import Author
from models.book_model import Book, BookStatus, BookType
from models.chapter_model import Chapter
from models.genre_model import Genre
from models.image_model import Image
from utils.fetch import fetch_html
from utils.logging import Logger

from .base_parser import BaseParser


class MangaseeParser(BaseParser):
    def __init__(
        self,
        url,
        book_url,
        chapter_url,
        logger: Logger,
        database_client: DatabaseClient,
    ):
        self.logger = logger
        self.database_client = database_client
        self.url = url
        self.book_url = book_url
        self.chapter_url = chapter_url
        # Load the configuration from the config.ini file
        self.load_config()

    def parse(self):
        self.logger.log("Initializing A.L.Y.S system...", log_level="STATE")
        start_time = datetime.now()
        self.logger.log(
            f"A.L.Y.S activated at: {start_time.strftime('%Y-%m-%d %H:%M:%S')}",
            log_level="STATE",
        )
        self.logger.log(
            f"Commencing data extraction from: {self.url}", log_level="STATE"
        )
        # Fetch the HTML content and parse the JSON string format
        html = fetch_html(self.url)
        if not html:
            self.logger.log("Failed to fetch HTML content.", log_level="ERROR")
            return

        start_pattern = "vm.Directory = "
        end_pattern = "}];"

        start_index = html.find(start_pattern)
        if start_index == -1:
            self.logger.log(
                "Start pattern ([vm.Directory =]) not found.", log_level="ERROR"
            )
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
            json_data = sorted(
                json.loads(json_string), key=lambda x: x.get("v", 0), reverse=True
            )
        except json.JSONDecodeError as e:
            self.logger.log(f"Error decoding JSON: {e}", log_level="ERROR")
            return

        self.logger.log(f"Found {len(json_data)} books.", log_level="SUCCESS")

        # Process the books
        for i, book in enumerate(json_data):
            # Limit the number of books to process
            if i < self.max_books:
                self.logger.log(
                    f"Processing first task for book {i + 1}/{len(json_data) if len(json_data)<self.max_books else self.max_books } : {book['i']}",
                    log_level="INFO",
                )
                # Fetch the book page and parse as a Book object
                book_html = fetch_html(self.book_url + book["i"])
                parsed_book = self.parseBook(book_html)
                if len(parsed_book.chapters) != 0:
                    # Insert the book into the database if it has (new) chapters
                    self.database_client.insert_book(parsed_book)

        self.logger.log(
            f"Completed processing {len(json_data)} books, {len(json_data) if len(json_data)<self.max_books else self.max_books } to insert.",
            log_level="SUCCESS",
        )
        end_time = datetime.now()
        self.logger.log(
            f"A.L.Y.S completed tasks at: {end_time.strftime('%Y-%m-%d %H:%M:%S')}",
            log_level="STATE",
        )
        self.logger.log(
            f"Total time active: {end_time - start_time}", log_level="STATE"
        )

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
                    parts = author_name.split(maxsplit=1)
                    if len(parts) == 2:
                        first_name, last_name = parts
                    else:
                        first_name, last_name = (
                            author_name,
                            "",
                        )  # Default last_name to empty if split fails

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

        # Check if the book is blacklisted
        if title in self.blacklisted_books:
            self.logger.log(
                f"Book {title} is blacklisted, skipping...", log_level="INFO"
            )
            return book

        # Extract Chapters
        return self.parseChapters(book, book_html)

    def process_single_chapter(self, book_html, chapter, book_title):
        # Extract chapter number and release date and turn into a Chapter object
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
            self.logger.log(
                "Start pattern ([vm.Chapters = ]) not found.", log_level="ERROR"
            )
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
            # Retrieve existing chapters from the database
            existing_chapters = self.database_client.get_book_chapters_from_title(
                book.title
            )
            data = json.loads(json_string)
            chapters_data = []
            # Skip the book if it has more than the chapter limit and is not whitelisted
            if (
                len(data) >= self.chapter_limit
                and book.title not in self.whitelisted_books
            ):
                self.logger.log(
                    f"{book.title} has {len(data)} chapters, the book has been skipped",
                    log_level="SUCCESS",
                )
            # Process all chapters if the book is whitelisted or has less than the chapter limit
            if len(data) < self.chapter_limit or book.title in self.whitelisted_books:
                for chapter in data:
                    # Check if the chapter is new
                    if (
                        (float(chapter["Chapter"]) % 100000) / 10
                    ) not in existing_chapters:
                        chapters_data.append(chapter)
                if len(chapters_data) != 0:
                    self.logger.log(
                        f"Found {len(chapters_data)} new chapters for : {book.title}",
                        log_level="SUCCESS",
                    )
                else:
                    self.logger.log(
                        f"No new chapters found for : {book.title}", log_level="SUCCESS"
                    )
        except json.JSONDecodeError as e:
            self.logger.log(f"Error decoding JSON: {e}", log_level="ERROR")
            return
        if len(chapters_data) != 0:
            with alive_bar(
                len(chapters_data),
                title=f"Processing chapters for {book.title}",
                spinner="classic",
            ) as bar:
                # Process the chapters in parallel
                with ThreadPoolExecutor(max_workers=self.max_threads) as executor:
                    future_to_chapter = {
                        executor.submit(
                            self.process_single_chapter, book_html, chapter, book.title
                        ): chapter
                        for chapter in chapters_data
                    }
                    for future in as_completed(future_to_chapter):
                        if future.exception() is not None:
                            self.logger.log(
                                f"Failed to process chapter: {future.exception()}",
                                log_level="ERROR",
                            )
                        chapter_obj = future.result()
                        book.add_chapter(chapter_obj)
                        bar()
                self.logger.log(
                    f"Chapters for book {book.title} processed successfully.",
                    log_level="SUCCESS",
                )
        return book

    def parseImages(self, index_name, chapter):
        self.logger.log(
            f"Parsing images for chapter: {chapter.number}", log_level="INFO"
        )

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
