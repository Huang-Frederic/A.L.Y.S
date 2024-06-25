class Image:
    def __init__(self, order, url):
        self.order = order
        self.url = url

    def __repr__(self):
        return f"Image(url='{self.url}', order={self.order})"
