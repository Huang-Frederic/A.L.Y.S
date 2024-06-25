import json
import os
import re
from pathlib import Path

from bs4 import BeautifulSoup
from models.author_model import Author
from models.book_model import Book, BookStatus, BookType
from models.chapter_model import Chapter
from models.genre_model import Genre
from utils.fetch import fetch_html

from .base_parser import BaseParser


class MangaseeParser(BaseParser):
    def __init__(self, url, book_url):
        self.url = url
        self.book_url = book_url
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
            if i == 5:
                break
            book_html = fetch_html(self.book_url + book["i"])
            books.append(self.parseBook(book_html))
            i = i + 1
            # if book["i"] == "Solo-Leveling":
            #     book_html = fetch_html(self.book_url + book["i"])
            #     books.append(self.parseBook(book_html))

        for book in books:
            print(book)

    def parseBook(self, book_html):
        soup = BeautifulSoup(book_html, "html.parser")

        