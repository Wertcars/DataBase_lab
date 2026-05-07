import json
import os

from dataclasses import asdict

from repository.base_repository import BaseRepository
from models import Product


class JsonRepository(BaseRepository):

    def __init__(self, filename="src/data/products.json"):

        self.filename = filename

        if not os.path.exists(filename):

            with open(filename, "w") as f:
                json.dump([], f)

    def _load(self):

        with open(self.filename, "r") as f:
            data = json.load(f)

        return [Product(**item) for item in data]

    def _save(self, products):

        with open(self.filename, "w") as f:
            json.dump(
                [asdict(p) for p in products],
                f,
                indent=4
            )

    def add(self, product):

        products = self._load()

        product.id = len(products) + 1

        products.append(product)

        self._save(products)

    def delete(self, product_id):

        products = self._load()

        products = [p for p in products if p.id != product_id]

        self._save(products)

    def update(self, product_id, **kwargs):

        products = self._load()

        for product in products:

            if product.id == product_id:

                for key, value in kwargs.items():

                    if hasattr(product, key):
                        setattr(product, key, value)

        self._save(products)

    def get_page(self, page=1, page_size=3):

        products = self._load()

        start = (page - 1) * page_size
        end = start + page_size

        return products[start:end]

    def get_all(self):
        return self._load()