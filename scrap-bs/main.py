import asyncio
import os
import time

from database.insert_db import insert_db
from parsers.mangasee_parser import MangaseeParser


def main():
    # Get the books from the Mangasee website
    MangaseeUrl = "https://mangasee123.com/search/?sort=v&desc=true"
    MangaseeBookUrl = "https://mangasee123.com/manga/"
    MangaseeChapterUrl = "https://mangasee123.com/read-online/"
    mangasee_books = MangaseeParser(
        MangaseeUrl, MangaseeBookUrl, MangaseeChapterUrl
    ).parse()

    # Insert the books into the database
    insert_db(mangasee_books)


if __name__ == "__main__":
    main()
