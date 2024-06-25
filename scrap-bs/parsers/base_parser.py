import json
import os
from abc import ABC, abstractmethod


class BaseParser(ABC):
    @abstractmethod
    def parse(self, html): ...

    def save_html_to_file(self, html):
        file_name = "saved_parsed.html"
        current_dir = os.getcwd()
        file_path = os.path.join(current_dir, file_name)

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(html)

        print(f"HTML saved to {file_path}")
