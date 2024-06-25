import os
import time

from parsers.mangasee_parser import MangaseeParser


def main():
    MangaseeUrl = "https://mangasee123.com/search/?sort=v&desc=true"
    MangaseeChapterUrl = "https://mangasee123.com/manga/"
    MangaseeParser(MangaseeUrl, MangaseeChapterUrl)


if __name__ == "__main__":
    main()
