class Chapter:
    def __init__(self, number, release):
        self.number = number
        self.release = release
        self.images = []

    def add_image(self, image_url):
        self.images.append(image_url)

    def __repr__(self):
        return f"Chapter(number={self.number}, release={self.release}, images={self.images})"
