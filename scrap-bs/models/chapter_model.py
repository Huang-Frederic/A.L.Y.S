class Chapter:
    def __init__(self, number):
        self.number = number
        self.images = []

    def add_image(self, image_url):
        self.images.append(image_url)

    def __repr__(self):
        return f"Chapter(number={self.number}, images={self.images})"
