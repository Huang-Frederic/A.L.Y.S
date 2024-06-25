class Image:
    def __init__(self, url):
        self.url = url

    def __repr__(self):
        return f"Image(url='{self.url}')"
