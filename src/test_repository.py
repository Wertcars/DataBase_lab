from models import Product

from repository.memory_repository import MemoryRepository
from repository.json_repository import JsonRepository
from repository.redis_repository import RedisRepository
from repository.sql_repository import SqlRepository


def run_tests(db):

    print("\n========== TEST START ==========\n")

    print("1. ADD PRODUCTS")

    p1 = Product(
        id=0,
        name="Chair",
        type="Furniture",
        price=120,
        size_x=1.2,
        size_y=0.8,
        is_avaliable=True,
        sub_type="Office",
        rating=4.5,
        weight=7
    )

    p2 = Product(
        id=0,
        name="Table",
        type="Furniture",
        price=300,
        size_x=2,
        size_y=1,
        is_avaliable=True,
        sub_type="Kitchen",
        rating=4.8,
        weight=15
    )

    db.add(p1)
    db.add(p2)

    print("Products added\n")

    print("2. GET ALL")

    products = db.get_all()

    for product in products:
        print(product)

    print()

    print("3. GET PAGE")

    page = db.get_page(1, 1)

    for product in page:
        print(product)

    print()

    print("4. UPDATE")

    db.update(
        1,
        price=999,
        rating=5
    )

    products = db.get_all()

    for product in products:
        print(product)

    print()

    print("5. DELETE")

    db.delete(1)

    products = db.get_all()

    for product in products:
        print(product)

    print()

    print("========== TEST END ==========\n")


if __name__ == "__main__":

    print("Choose repository:")
    print("1 - Memory")
    print("2 - JSON")
    print("3 - Redis")
    print("4 - SQLite")

    choice = input("Choice: ")

    if choice == "1":
        db = MemoryRepository()

    elif choice == "2":
        db = JsonRepository()

    elif choice == "3":
        db = RedisRepository()

    elif choice == "4":
        db = SqlRepository()

    else:
        print("Invalid choice")
        exit()

    run_tests(db)