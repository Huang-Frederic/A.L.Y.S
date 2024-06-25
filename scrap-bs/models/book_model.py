from enum import Enum

from .author_model import Author
from .genre_model import Genre


class BookType(Enum):
    MANHWA = "Manhwa"
    MANHUA = "Manhua"
    MANGA = "Manga"


class BookStatus(Enum):
    COMPLETE = "Complete"
    ONGOING = "Ongoing"
    HIATUS = "Hiatus"


class Book:
    def __init__(self, title, release, book_type, status, description, cover_url):
        self.title = title
        self.release = release  # Only the Year
        self.type = book_type  # BookType Enum
        self.status = status  # BookSatus Enum
        self.description = description
        self.cover_url = cover_url
        self.authors = []  # List of Author objects
        self.genres = []  # List of Genre objects
        self.chapters = []  # List of Chapter objects

    def add_authors(self, authors):
        if isinstance(authors, list):
            for author in authors:
                if isinstance(author, Author):
                    self.authors.append(author)
                else:
                    raise TypeError("Expected an instance of Author class.")
        else:
            raise TypeError("Expected a list of Author instances.")

    def add_genres(self, genres):
        if isinstance(genres, list):
            for genre in genres:
                if isinstance(genre, Genre):
                    self.genres.append(genre)
                else:
                    raise TypeError("Expected an instance of Genre class.")
        else:
            raise TypeError("Expected a list of Genre instances.")

    def add_chapter(self, chapter):
        self.chapters.append(chapter)

    def __repr__(self):
        authors_str = (
            ", ".join(
                f"{author.first_name} {author.last_name}" for author in self.authors
            )
            if self.authors
            else "Unknown"
        )
        genres_str = (
            ", ".join(genre.name for genre in self.genres) if self.genres else "Unknown"
        )
        chapters_count = len(self.chapters)

        return (
            f"Book(title='{self.title}', "
            f"release={self.release}, "
            f"type={self.type.value}, "
            f"status={self.status.value}, "
            f"description='{self.description[:50]}...', "  # Show first 50 characters of description
            f"cover_url='{self.cover_url}', "
            f"authors=[{authors_str}], "
            f"genres=[{genres_str}], "
            f"chapters={chapters_count} chapters)"
        )
