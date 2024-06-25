import os
import time

from parsers.mangasee_parser import MangaseeParser


def main():
    MangaseeUrl = "https://mangasee123.com/search/?sort=v&desc=true"
    MangaseeBookUrl = "https://mangasee123.com/manga/"
    MangaseeChapterUrl = "https://mangasee123.com/read-online/"
    MangaseeParser(MangaseeUrl, MangaseeBookUrl, MangaseeChapterUrl)


if __name__ == "__main__":
    main()
