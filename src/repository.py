from models import Product

class BaseModel:
    def __init__(self):
        self.products: list[Product] = []
        self._next_id = 1

    def add(self, products: Product):
        products.id = self._next_id
        self._next_id += 1
        self.products.append(products)

    def delete(self, product_id: int):
        for i in self.products:
            if i.id == product_id:
                self.products.remove(i)
                return "Product has been deleted"
        return "Product not found"
                
    def update(self, product_id: int, **kwargs):
        product = None

        for i in self.products:
            if i.id == product_id:
                product = i
                break

        if product is None:
            return "Product not found"
        
        for key, value in kwargs.items():
            if hasattr(i, key):
                setattr(i, key, value)
        return "Product updated"

    def get_page(self, page: int = 1, page_size: int = 3):
        start = (page - 1) * page_size
        end = start + page_size
        return self.products[start:end]

    def get_all(self):
        return self.products