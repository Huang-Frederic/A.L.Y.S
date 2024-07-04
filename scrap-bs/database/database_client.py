import configparser
import os
from concurrent.futures import ThreadPoolExecutor, as_completed

from alive_progress import alive_bar
from dotenv import load_dotenv
from supabase import create_client
from utils.logging import Logger

load_dotenv()


class DatabaseClient:
    def __init__(self, logger: Logger):
        # Configure logging
        self.logger = logger
        self.init_client()
        self.load_config()

    def init_client(self):
        # Load environment variables
        required_env_vars = ["SUPABASE_URL", "SUPABASE_KEY"]
        missing_vars = [var for var in required_env_vars if not os.getenv(var)]

        if missing_vars:
            self.logger.log(
                f'Missing environment variables: {", ".join(missing_vars)}',
                log_level="ERROR",
            )
            raise EnvironmentError(
                f'Missing environment variables: {", ".join(missing_vars)}'
            )

        # Configure Supabase client
        self.SUPABASE_URL = os.getenv("SUPABASE_URL")
        self.SUPABASE_KEY = os.getenv("SUPABASE_KEY")
        self.supabase = create_client(self.SUPABASE_URL, self.SUPABASE_KEY)  # type: ignore

    def load_config(self):
        config = configparser.ConfigParser()
        config.read("config.ini")
        self.max_threads = config.getint("multithreading", "max_threads", fallback=6)

    def insert_book(self, book):
        if not book:
            self.logger.log(
                "Error occured, tried to insert a ghostly book ", log_level="ERROR"
            )
            return

        self.logger.log(
            f"Initializing A.L.Y.S second task for {book.title}", log_level="STATE"
        )

        # Insert the book if it doesn't exist
        book_id = self.insert_or_get_book_id(book)

        # Insert authors if they don't exist and link to the book
        for author in book.authors:
            author_id = self.insert_author_if_not_exists(author)
            self.link_book_author(book_id, author_id)

        # Insert genres if they don't exist and link to the book
        for genre in book.genres:
            genre_id = self.insert_genre_if_not_exists(genre)
            self.link_book_genre(book_id, genre_id)

        # Insert chapters if they don't exist and link to the book
        with alive_bar(len(book.chapters), title=book.title, spinner=None) as bar:
            with ThreadPoolExecutor(max_workers=self.max_threads) as executor:
                futures = [
                    executor.submit(
                        self.process_chapter_insertion, book_id, chapter_data
                    )
                    for chapter_data in book.chapters
                ]

                for future in as_completed(futures):
                    future.result()
                    bar()

        self.logger.log(
            f"A.L.Y.S completed second task : {book.title}", log_level="STATE"
        )

    def process_chapter_insertion(self, book_id, chapter_data):
        self.logger.log(f"Inserting chapter {chapter_data.number}", log_level="INFO")
        chapter_id = self.insert_or_get_chapter_id(book_id, chapter_data)

        # Insert images if they don't exist and link to the chapter
        for image_data in chapter_data.images:
            self.insert_image_if_not_exists(chapter_id, image_data)

    def insert_or_get_book_id(self, book):
        # Check if the book already exists
        existing_book_response = (
            self.supabase.table("books")
            .select("id")
            .eq("title", book.title)
            .eq("release", book.release)
            .execute()
        )

        if existing_book_response.data:
            self.logger.log(f"Book {book.title} already exists", log_level="DEBUG")
            book_id = existing_book_response.data[0]["id"]
        else:
            # Insert the book if it doesn't exist
            inserted_book_response = (
                self.supabase.table("books")
                .insert(
                    {
                        "title": book.title,
                        "release": book.release,
                        "type": book.type.value,
                        "status": book.status.value,
                        "description": book.description,
                        "cover_url": book.cover_url,
                    }
                )
                .execute()
            )

            if inserted_book_response.data:
                self.logger.log(f"Inserted book {book.title}", log_level="DEBUG")
                book_id = inserted_book_response.data[0]["id"]
            else:
                raise Exception(f"Failed to insert book: {inserted_book_response}")

        return book_id

    def insert_author_if_not_exists(self, author):
        # Check if author exists
        existing_author_response = (
            self.supabase.table("authors")
            .select("id")
            .eq("first_name", author.first_name)
            .eq("last_name", author.last_name)
            .execute()
        )

        if existing_author_response.data:
            self.logger.log(
                f"Author {author.first_name} {author.last_name} already exists",
                log_level="DEBUG",
            )
            author_id = existing_author_response.data[0]["id"]
        else:
            # Insert new author
            inserted_author_response = (
                self.supabase.table("authors")
                .insert(
                    {"first_name": author.first_name, "last_name": author.last_name}
                )
                .execute()
            )

            if inserted_author_response.data:
                self.logger.log(
                    f"Inserted author {author.first_name} {author.last_name}",
                    log_level="DEBUG",
                )
                author_id = inserted_author_response.data[0]["id"]
            else:
                raise Exception(f"Failed to insert author: {inserted_author_response}")

        return author_id

    def link_book_author(self, book_id, author_id):
        # Check if the link between book and author already exists
        existing_link_response = (
            self.supabase.table("book_authors")
            .select("*")
            .eq("book_id", book_id)
            .eq("author_id", author_id)
            .execute()
        )

        if not existing_link_response.data:
            # Link book to author
            insert_response = (
                self.supabase.table("book_authors")
                .insert({"book_id": book_id, "author_id": author_id})
                .execute()
            )

            if not insert_response.data:
                raise Exception(f"Failed to link book and author: {insert_response}")

    def insert_genre_if_not_exists(self, genre):
        # Check if genre exists
        existing_genre_response = (
            self.supabase.table("genres").select("id").eq("name", genre.name).execute()
        )

        if existing_genre_response.data:
            self.logger.log(f"Genre {genre.name} already exists", log_level="DEBUG")
            genre_id = existing_genre_response.data[0]["id"]
        else:
            # Insert new genre
            inserted_genre_response = (
                self.supabase.table("genres").insert({"name": genre.name}).execute()
            )

            if inserted_genre_response.data:
                self.logger.log(f"Inserted genre {genre.name}", log_level="DEBUG")
                genre_id = inserted_genre_response.data[0]["id"]
            else:
                raise Exception(f"Failed to insert genre: {inserted_genre_response}")

        return genre_id

    def link_book_genre(self, book_id, genre_id):
        # Check if the link between book and genre already exists
        existing_link_response = (
            self.supabase.table("book_genres")
            .select("*")
            .eq("book_id", book_id)
            .eq("genre_id", genre_id)
            .execute()
        )

        if not existing_link_response.data:
            # Link book to genre
            insert_response = (
                self.supabase.table("book_genres")
                .insert({"book_id": book_id, "genre_id": genre_id})
                .execute()
            )

            if not insert_response.data:
                raise Exception(f"Failed to link book and genre: {insert_response}")

    def insert_or_get_chapter_id(self, book_id, chapter_data):
        # Check if chapter exists
        existing_chapter_response = (
            self.supabase.table("chapters")
            .select("id")
            .eq("number", chapter_data.number)
            .eq("book_id", book_id)
            .execute()
        )

        if existing_chapter_response.data:
            self.logger.log(
                f"Chapter {chapter_data.number} already exists", log_level="DEBUG"
            )
            chapter_id = existing_chapter_response.data[0]["id"]
        else:
            # Insert new chapter
            inserted_chapter_response = (
                self.supabase.table("chapters")
                .insert(
                    {
                        "number": chapter_data.number,
                        "release": chapter_data.release,
                        "book_id": book_id,
                    }
                )
                .execute()
            )

            if inserted_chapter_response.data:
                self.logger.log(
                    f"Inserted chapter {chapter_data.number}", log_level="DEBUG"
                )
                chapter_id = inserted_chapter_response.data[0]["id"]
            else:
                raise Exception(
                    f"Failed to insert chapter: {inserted_chapter_response}"
                )

        return chapter_id

    def insert_image_if_not_exists(self, chapter_id, image_data):
        # Check if image exists
        existing_image_response = (
            self.supabase.table("images")
            .select("id")
            .eq("chapter_id", chapter_id)
            .eq("number", image_data.number)
            .execute()
        )

        if not existing_image_response.data:
            # Insert new image
            inserted_image_response = (
                self.supabase.table("images")
                .insert(
                    {
                        "url": image_data.url,
                        "number": image_data.number,
                        "chapter_id": chapter_id,
                    }
                )
                .execute()
            )

            if not inserted_image_response.data:
                raise Exception(f"Failed to insert image: {inserted_image_response}")

    def get_book_chapters_from_title(self, book_title):
        book_id = self.get_book_id_by_title(book_title)
        if not book_id:
            return []

        # Get chapters for a book
        response = (
            self.supabase.table("chapters")
            .select("number")
            .eq("book_id", book_id)
            .execute()
        )

        if response.data:
            return [chapter["number"] for chapter in response.data]
        else:
            return []

    def get_book_id_by_title(self, book_title):
        # Query the book_id based on book_title
        book_response = (
            self.supabase.table("books")
            .select("id")
            .eq("title", book_title)
            .limit(1)
            .execute()
        )

        if book_response.data:
            return book_response.data[0]["id"]
        else:
            return None
