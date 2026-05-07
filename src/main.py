from repository.memory_repository import MemoryRepository
from repository.json_repository import JsonRepository
from repository.redis_repository import RedisRepository
from repository.sql_repository import SqlRepository


print("Choose storage:")
print("1 - Memory")
print("2 - JSON")
print("3 - Redis")
print("4 - SQL Server")

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