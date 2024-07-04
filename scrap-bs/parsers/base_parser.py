import configparser
import json
import os
from abc import ABC, abstractmethod


class BaseParser(ABC):
    @abstractmethod
    def parse(self, html):
        ...

    def save_html_to_file(self, html):
        file_name = "saved_parsed.html"
        current_dir = os.getcwd()
        file_path = os.path.join(current_dir, file_name)

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(html)

        print(f"HTML saved to {file_path}")

    def load_config(self):
        config = configparser.ConfigParser()
        config.read("config.ini")
        self.chapter_limit = config.getint("scraping", "chapter_limit", fallback=500)
        self.max_books = config.getint("scraping", "max_books", fallback=1000)
        self.max_threads = config.getint("multithreading", "max_threads", fallback=6)
