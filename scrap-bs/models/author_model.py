class Author:
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name

    def __repr__(self):
        return f"Author(first_name='{self.first_name}', last_name='{self.last_name}')"
