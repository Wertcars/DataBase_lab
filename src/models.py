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
        size = f"{self.size_x}m x {self.size_y}m"

        return (
            f"ID: {self.id} | "
            f"Name: {self.name} | "
            f"Type: {self.type} | "
            f"Sub-type: {self.sub_type} | "
            f"Price: {self.price}$ | "
            f"Rating: {self.rating}* | "
            f"Weight: {self.weight}kg | "
            f"Size: {size} | "
            f"Available: {self.is_avaliable}"
        )