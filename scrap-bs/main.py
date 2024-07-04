from database.database_client import DatabaseClient
from parsers.mangasee_parser import MangaseeParser
from utils.logging import Logger


def main():
    # Initialize the logger and database client
    logger = Logger()
    database_client = DatabaseClient(logger)

    # Get, Parse and Insert from the Mangasee website
    MangaseeUrl = "https://mangasee123.com/search/?sort=v&desc=true"
    MangaseeBookUrl = "https://mangasee123.com/manga/"
    MangaseeChapterUrl = "https://mangasee123.com/read-online/"
    MangaseeParser(
        MangaseeUrl, MangaseeBookUrl, MangaseeChapterUrl, logger, database_client
    ).parse()

    logger.log("A.L.Y.S returned to sleep ...", log_level="STATE")
    logger.close()


if __name__ == "__main__":
    main()
