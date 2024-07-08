# 📍 A.L.Y.S (Aeonian Library for Yearning Seekers)

A.L.Y.S (Aeonian Library for Yearning Seekers) is a full-stack project I'm developing from scratch as a personal challenge in my third year as a developer. This project aims to centralize popular manhwa, manhua, and manga into one platform accessible through both a website and a mobile app. The principle behind A.L.Y.S is to scrape various sites to retrieve artwork and reunite them in one platform. Through meticulous development, we're striving to create a unified space where enthusiasts can indulge in their favorite genres without the hassle of navigating multiple sources.

## 🔮 Stack

Database

![Static Badge](https://img.shields.io/badge/Postgresql-grey?style=for-the-badge&logo=Postgresql)
![Static Badge](https://img.shields.io/badge/Supabase-grey?style=for-the-badge&logo=Supabase)

Scraping Script :

![Static Badge](https://img.shields.io/badge/Python-grey?style=for-the-badge&logo=Python)
![Static Badge](https://img.shields.io/badge/BS4-grey?style=for-the-badge&logo=BS4)
![Static Badge](https://img.shields.io/badge/Playwright-grey?style=for-the-badge&logo=Playwright)

Mobile App :

![Static Badge](https://img.shields.io/badge/Flutter-grey?style=for-the-badge&logo=Flutter)

## 🌐 Project Overview - Global

The project is divided into two distinct parts: the scraping component, which is responsible for collecting and processing data from various sources, and the Flutter component, which handles the user interface and user experience of the ALYS application. Each part plays a crucial role in ensuring the functionality and usability of the project.

### File Structure

```txt
A.L.Y.S/
├── scrap-bs/
├── ui-flutter/
├── .gitignore
├── .pre-commit-config.yaml
├── LICENCE
├── README.md
```

## 👨‍🚀 Before Getting Started - Message to Developers

This section is reserved for developers who wish to contribute to the base code of the ALYS project. If you do not intend to make contributions to the core code, you can safely skip this part. ALYS is a large and structured project, which requires a bit of setup before you can start working on the various components.

To ensure consistency and quality across the codebase, I use pre-commit hooks. These hooks help enforce coding standards and catch common errors before commits are made. Follow the instructions below to set up pre-commit hooks

System Requirements:

- Python 3.10+
- Package managers : pip

> Clone the repository (if you have already cloned it, skip this step)

```bash
$ git clone https://github.com/Huang-Frederic/A.L.Y.S
$ cd A.L.Y.S
```

> Install pre-commit

```bash
$ pip install pre-commit
$ pre-commit install
```

> [!TIP]
> You can check if pre-commit has been successfully setup in your project by running the following command : `pre-commit run --all-files`

By setting up and using pre-commit hooks, we can maintain a high standard of code quality and ensure that our codebase remains clean and error-free. Thank you for contributing to ALYS!

## 🌐 Project Overview - Scraping Script Part

The ALYS scraping system is a modular Python-based solution designed to collect data from various manhwa, manhua, and manga websites. It features a flexible parser architecture, allowing easy addition of new sources by creating specific parser modules that extend a base class. The system fetches HTML content, parses detailed metadata for books, chapters, and images, and inserts this data into the ALYS database while maintaining data integrity. Robust logging with configurable log levels ensures detailed tracking of the scraping process. Additionally, multithreading is used to enhances performance, efficiently managing large data sets.

### File Structure

The key files and directories related to the scraping script part are isolated in the `scrap-bs` folder and is structured as follows:

```txt
scrap-bs/
├── database/
│   └── database_client.py
│   └── db.sql
├── logs/
├── models/
│   └── author_model.py/
│   └── book_model.py/
│   └── chapter_model.py/
│   └── genre_model.py/
│   └── image_model.py/
├── parsers/
│   └── base_parser.py/
│   └── mangasee_parser.py/
├── utils/
│   └── fetch.py/
│   └── logging.py/
├── config.ini
├── main.py
├── requirements.txt
```

## 🚀 Getting Started

System Requirements:

- Python 3.10+
- Package managers : pip
- Supabase account

## 🛰️ Environnement Variables

These environnement variables are required for Supabase integrations :

```env
SUPABASE_URL = "https://your_url.supabase.co"
SUPABASE_KEY = "your secret key"
```

## 💻 Installation

### From source

> Clone the repository (if you have already the repository in your computer, skip this step)

```bash
$ git clone https://github.com/Huang-Frederic/A.L.Y.S
$ cd A.L.Y.S
```

> Install Python Dependencies

```bash
$ cd script-bs
$ python -m venv env
$ env/bin/activate  # On Windows, use `env\Scripts\activate`
$ pip install --no-deps -r requirements.txt
```

> Create a Supabase Project

```txt
    Books Table:
    - id: Unique identifier for each book (automatically generated)
    - title: Title of the book
    - type: Type of the book (e.g., manga, manhua, manhwa)
    - status: Status of the book (e.g., ongoing, completed)
    - description: Brief description of the book
    - cover_url: URL of the book's cover image
    - release: Year the book was released

    Chapters Table:
    - id: Unique identifier for each chapter (automatically generated)
    - number: Chapter number
    - book_id: ID of the book to which the chapter belongs
    - release: Release date of the chapter

    Images Table:
    - id: Unique identifier for each image (automatically generated)
    - number: Image number within the chapter
    - url: URL of the image
    - chapter_id: ID of the chapter to which the image belongs

    Genres Table:
    - id: Unique identifier for each genre (automatically generated)
    - name: Name of the genre

    Book Genres Table:
    - book_id: ID of the book
    - genre_id: ID of the genre

    Authors Table:
    - id: Unique identifier for each author (automatically generated)
    - first_name: First name of the author
    - last_name: Last name of the author

    7. Book Authors Table:
    - book_id: ID of the book
    - author_id: ID of the author
```

> [!TIP]
> You can copy the queries in the db.sql file (./scrap-bs/database/db.sql) and copy paste it in the Supabase SQL Editor

> Set Up Environment Variables

```bash
# Create a .env file in the root directory of your project and add the following environment variables

SUPABASE_URL = "https://your_url.supabase.co"
SUPABASE_KEY = "your secret key"
```

## 🛠️ Configs

The ALYS scraping system includes a config.ini file that allows users to customize the script's behavior.

```ini
# ./scrap-bs/config.ini

[logging]
show_debug_logs = True
## show the debug logs in the console (the debug logs will still be saved in the log files)

[scraping]
fetch_timeout = 60000
## timeout for fetching a page in milliseconds
chapter_limit = 500
## ignore books with more than [chapter_limit] chapters, it can helps to avoid storage issues
max_books = 1000
## maximum number of books to scrape

blacklisted_books = ["Dr. STONE", "One-Piece"]
## list of books that will will be excluded no matter what
whitelisted_books = ["Naruto"]
## list of books that will be scraped no matter what
# eggs. ["book_title_1", "book_title_2", "book_title_3"]

[multithreading]
max_threads = 6
## maximum number of threads to use for scraping (recommended: 80% of your CPU cores if your idleing)
```

> [!NOTE]
> With the default settings, ALYS can scrape approximately 3000 chapters per hour, which includes around 100,000 images and generates about 15MB of data.

> Run the script

```bash
$ python main.py

# -> And now you should see the values starting to appear in your database
```

## 🚶‍♂️ Author

- [@Huang-Frederic](https://github.com/Huang-Frederic)

## 🔗 Acknowledgements

Parsed Website(s) :

- [Mangasee123](https://mangasee123.com/)

Ressources :

- [Bash Progress Bar](https://github.com/lnfnunes/bash-progress-indicator)

Usefull Documentations :

- [Supabase Docs](https://supabase.com/docs)
