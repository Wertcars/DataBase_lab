from models import Product
from database import BaseModel
import testing

db = testing.db

def create_product():
    name = input("Name: ") 
    type = input("Type: ")
    price_input = input("Price: ").strip()
    price = float(price_input) if price_input else None
    sub_type_input = input("Sub type (optional): ").strip()
    sub_type = str(sub_type_input) if sub_type_input else None
    rating_input = input("Rating (optional): ").strip()
    rating = float(rating_input) if rating_input else None
    weight_input = input("Weight (optional): ").strip()
    weight = float(weight_input) if weight_input else None
    size = input("Size (example 2.4x1.2) in meters: ")

    size_x = None
    size_y = None

    if size:
        parts = size.lower().split("x")
        if len(parts) == 2:
            size_x = float(parts[0])
            size_y = float(parts[1])

    is_available = input("Is available (true/false): ").lower() == "true"

    product = Product(
        id = 0,
        name=name,
        type=type,
        sub_type=sub_type,
        price=price,
        rating=rating,
        weight=weight,
        size_x=size_x,
        size_y=size_y,
        is_avaliable=is_available
        )
    
    db.add(product)
    print(f"Product added, ID: {product.id}")

def update_product():
    sub_type = input("New sub-type: ")
    price = float(input("New price: "))
    rating = float(input("New rating: "))
    is_available = (input("Is available (true/false): ").lower() in ["true", "yes", "1"])

    result = db.update(sub_type=sub_type, price=price, rating=rating, is_avaliable=is_available)

    if result:
        print("Product updated")
    else:
        print("Product not found")

def delete_product():
    product_id = int(input("Enter product ID: "))
    print(db.delete(product_id))

def show_products():
    page = int(input("Page number: "))
    products = db.get_page(page)

    for product in products:
        print(product)

def main():
    while True:
        print("1. Create product")
        print("2. Update product")
        print("3. Delete product")
        print("4. Show products")
        print("5. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            create_product()
        elif choice == "2":
            update_product()
        elif choice == "3":
            delete_product()
        elif choice == "4":
            show_products()
        elif choice == "5":
            break
        else:
            print("Invalid choice")

if __name__ == "__main__":
    main()
