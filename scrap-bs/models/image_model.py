class Image:
    def __init__(self, number, url):
        self.number = number
        self.url = url

    def __repr__(self):
        return f"Image(url='{self.url}', order={self.number})"
