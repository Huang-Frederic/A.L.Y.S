import json
import os
import re
from pathlib import Path

from bs4 import BeautifulSoup
from utils.fetch import fetch_html

from .base_parser import BaseParser


class MangaseeParser(BaseParser):
    def __init__(self, url, chapter_url):
        self.url = url
        self.chapter_url = chapter_url
        self.html = fetch_html(self.url)

        # self.save_html_to_file(self.html)
        self.parse(self.html)

    def parse(self, html):
        # Define the start and end of the json pattern
        start_pattern = "vm.Directory = "
        end_pattern = "}];"

        # Find the starting index of the json pattern
        start_index = html.find(start_pattern)
        if start_index == -1:
            print("Start pattern not found.")
            return
        start_index += len(start_pattern)

        # Find the ending index of the pattern
        end_index = html.find(end_pattern, start_index)
        if end_index == -1:
            print("End pattern not found.")
            return
        end_index += len(end_pattern)
        json_string = html[start_index:end_index].rstrip(";")

        try:
            json_data = json.loads(json_string)
        except json.JSONDecodeError as e:
            print("Error decoding JSON:", e)

        i = 0
        for book in json_data:
            if i < 10:
                chapter_html = fetch_html(self.chapter_url + book["i"])
                self.parseChapter(chapter_html)
                print("HTML successfully saved for", book["i"])
                i = i + 1
            else:
                break

    def parseChapter(self, chapter_html):
        self.save_html_to_file(chapter_html)
