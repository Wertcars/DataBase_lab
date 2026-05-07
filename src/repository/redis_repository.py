import redis

from repository.base_repository import BaseRepository
from proto import product_pb2
from models import Product


class RedisRepository(BaseRepository):

    def __init__(self):

        self.redis_client = redis.Redis(
            host='localhost',
            port=6379,
            db=0
        )

        self.current_id = 1

    def add(self, product):

        product_proto = product_pb2.Product()

        product.id = self.current_id
        self.current_id += 1
        product_proto.name = product.name
        product_proto.type = product.type
        product_proto.price = product.price
        product_proto.size_x = product.size_x
        product_proto.size_y = product.size_y
        product_proto.is_avaliable = product.is_avaliable

        if product.sub_type:
            product_proto.sub_type = product.sub_type

        if product.rating:
            product_proto.rating = product.rating

        if product.weight:
            product_proto.weight = product.weight

        self.redis_client.set(
            f"product:{product.id}",
            product_proto.SerializeToString()
        )

    def get_all(self):

        result = []

        for key in self.redis_client.keys("product:*"):

            data = self.redis_client.get(key)

            product_proto = product_pb2.Product()

            product_proto.ParseFromString(data)

            result.append(
                Product(
                    id=product_proto.id,
                    name=product_proto.name,
                    type=product_proto.type,
                    price=product_proto.price,
                    size_x=product_proto.size_x,
                    size_y=product_proto.size_y,
                    is_avaliable=product_proto.is_avaliable,
                    sub_type=product_proto.sub_type,
                    rating=product_proto.rating,
                    weight=product_proto.weight
                )
            )

        return result
    
    def delete(self, product_id):
        self.redis_client.delete(f"product:{product_id}")

        return "Deleted"
    
    def update(self, product_id, **kwargs):

        key = f"product:{product_id}"

        data = self.redis_client.get(key)

        if not data:
            return "Not found"

        product_proto = product_pb2.Product()

        product_proto.ParseFromString(data)

        for key_attr, value in kwargs.items():

            if hasattr(product_proto, key_attr):
                setattr(product_proto, key_attr, value)

        self.redis_client.set(
            key,
            product_proto.SerializeToString()
        )

        return "Updated"
    
    def get_page(self, page=1, page_size=3):

        products = self.get_all()
        start = (page - 1) * page_size
        end = start + page_size

        return products[start:end]