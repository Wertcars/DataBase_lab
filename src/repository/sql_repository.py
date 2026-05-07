import sqlite3
import os

from repository.base_repository import BaseRepository
from models import Product


class SqlRepository(BaseRepository):

    def __init__(self):

        db_path = "src/data/products.db"

        db_path = os.path.normpath(db_path)

        self.connection = sqlite3.connect(db_path)

        self.cursor = self.connection.cursor()

        self.create_table()

    def create_table(self):

        query = """
        CREATE TABLE IF NOT EXISTS products (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            name TEXT NOT NULL UNIQUE,

            type TEXT NOT NULL,

            price REAL NOT NULL
                CHECK(price > 0),

            size_x REAL NOT NULL
                CHECK(size_x > 0),

            size_y REAL NOT NULL
                CHECK(size_y > 0),

            is_available INTEGER NOT NULL DEFAULT 1,

            sub_type TEXT,

            rating REAL
                CHECK(rating BETWEEN 0 AND 5),

            weight REAL
                CHECK(weight > 0)
        )
        """

        self.cursor.execute(query)

        self.connection.commit()

    def add(self, product):

        query = """
        INSERT INTO products
        (
            name,
            type,
            price,
            size_x,
            size_y,
            is_available,
            sub_type,
            rating,
            weight
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """

        self.cursor.execute(
            query,
            (
                product.name,
                product.type,
                product.price,
                product.size_x,
                product.size_y,
                product.is_avaliable,
                product.sub_type,
                product.rating,
                product.weight
            )
        )

        self.connection.commit()

    def delete(self, product_id):

        query = "DELETE FROM products WHERE id = ?"

        self.cursor.execute(query, (product_id,))

        self.connection.commit()

        return "Deleted"

    def update(self, product_id, **kwargs):

        if not kwargs:
            return "Nothing to update"

        fields = []
        values = []

        for key, value in kwargs.items():

            if key == "is_avaliable":
                key = "is_available"

            fields.append(f"{key} = ?")
            values.append(value)

        values.append(product_id)

        query = f"""
        UPDATE products
        SET {', '.join(fields)}
        WHERE id = ?
        """

        self.cursor.execute(query, values)

        self.connection.commit()

        return "Updated"

    def get_all(self):

        query = "SELECT * FROM products"

        self.cursor.execute(query)

        rows = self.cursor.fetchall()

        result = []

        for row in rows:

            result.append(
                Product(
                    id=row[0],
                    name=row[1],
                    type=row[2],
                    price=row[3],
                    size_x=row[4],
                    size_y=row[5],
                    is_avaliable=bool(row[6]),
                    sub_type=row[7],
                    rating=row[8],
                    weight=row[9]
                )
            )

        return result

    def get_page(self, page=1, page_size=3):

        offset = (page - 1) * page_size

        query = """
        SELECT * FROM products
        LIMIT ? OFFSET ?
        """

        self.cursor.execute(query, (page_size, offset))

        rows = self.cursor.fetchall()

        result = []

        for row in rows:

            result.append(
                Product(
                    id=row[0],
                    name=row[1],
                    type=row[2],
                    price=row[3],
                    size_x=row[4],
                    size_y=row[5],
                    is_avaliable=bool(row[6]),
                    sub_type=row[7],
                    rating=row[8],
                    weight=row[9]
                )
            )

        return result