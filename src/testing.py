from database import BaseModel
from models import Product

db = BaseModel()

products = [
    Product(id=0,name="Laptop", type="Electronics", sub_type="Computer", price=1200.0, rating=4.7, weight=2.5, size_x=15.0, size_y=10.0, is_avaliable=True),
    Product(id=0, name="Phone", type="Electronics", sub_type="Smartphone", price=800.0, rating=4.5, weight=0.3, size_x=6.0, size_y=3.0, is_avaliable=True),
    Product(id=0, name="Tablet", type="Electronics", sub_type="Tablet", price=500.0, rating=4.3, weight=0.7, size_x=10.0, size_y=7.0, is_avaliable=True),
    Product(id=0, name="Monitor", type="Electronics", sub_type="Display", price=300.0, rating=4.2, weight=4.0, size_x=24.0, size_y=14.0, is_avaliable=True),
    Product(id=0, name="Keyboard", type="Accessory", sub_type="Input", price=50.0, rating=4.0, weight=0.8, size_x=18.0, size_y=6.0, is_avaliable=True),
    Product(id=0, name="Mouse", type="Accessory", sub_type="Input", price=30.0, rating=4.1, weight=0.2, size_x=5.0, size_y=3.0, is_avaliable=True)
]

for p in products:
    db.add(p)