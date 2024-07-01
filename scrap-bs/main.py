import asyncio
import os
import time

from utils.logging import Logger
from database.database_client import DatabaseClient
from parsers.mangasee_parser import MangaseeParser


def main():
    # Initialize the logger and database client
    logger = Logger()
    database_client = DatabaseClient(logger)

    # Get the books from the Mangasee website
    MangaseeUrl = "https://mangasee123.com/search/?sort=v&desc=true"
    MangaseeBookUrl = "https://mangasee123.com/manga/"
    MangaseeChapterUrl = "https://mangasee123.com/read-online/"
    mangasee_books = MangaseeParser(
        MangaseeUrl, MangaseeBookUrl, MangaseeChapterUrl, logger, database_client
    ).parse()

    # Insert the books into the database
    database_client.insert_data(mangasee_books)

    logger.log("A.L.Y.S returned to sleep ...", log_level="STATE")
    logger.close()


if __name__ == "__main__":
    main()
