from repository.base_repository import BaseRepository

class MemoryRepository(BaseRepository):

    def __init__(self):
        self.products = []
        self._next_id = 1

    def add(self, product):
        product.id = self._next_id
        self._next_id += 1

        self.products.append(product)

    def delete(self, product_id):

        for product in self.products:
            if product.id == product_id:
                self.products.remove(product)
                return "Deleted"

        return "Not found"

    def update(self, product_id, **kwargs):

        for product in self.products:

            if product.id == product_id:

                for key, value in kwargs.items():

                    if hasattr(product, key):
                        setattr(product, key, value)

                return "Updated"

        return "Not found"

    def get_page(self, page=1, page_size=3):

        start = (page - 1) * page_size
        end = start + page_size

        return self.products[start:end]

    def get_all(self):
        return self.products