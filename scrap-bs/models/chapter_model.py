class Chapter:
    def __init__(self, number, release):
        self.number = number
        self.release = release
        self.images = []

    def add_image(self, image):
        self.images.append(image)

    def __repr__(self):
        images_count = len(self.images)
        return f"Chapter(number={self.number}, release={self.release}, images({images_count})={self.images[:3]}...)"
