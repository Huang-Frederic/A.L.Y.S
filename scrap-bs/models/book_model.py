class Book:
    def __init__(self, title):
        self.title = title
        self.chapters = []

    def add_chapter(self, chapter):
        self.chapters.append(chapter)

    def __repr__(self):
        return f"Book(title='{self.title}', chapters={self.chapters})"
