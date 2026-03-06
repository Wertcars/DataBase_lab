from typing import Optional
from dataclasses import dataclass

@dataclass
class Product:
    id: int
    name: str
    type: str
    price: float
    size_x: float
    size_y: float
    is_avaliable: bool
    sub_type: str = None
    rating: float = None
    weight: float = None

    def __str__(self):  
        if self.size_x and self.size_y:
            size = f"{self.size_x}m x {self.size_y}m"
        return f"ID: {self.id} | Name: {self.name} | Type: {self.type} | Sub-type: {self.sub_type} | Price: {self.price}$ | Rating: {self.rating}* | Weight: {self.weight}kg | Size: {size} | Available: {self.is_avaliable}"