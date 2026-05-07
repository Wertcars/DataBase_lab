from abc import ABC, abstractmethod

class BaseRepository(ABC):

    @abstractmethod
    def add(self, product):
        pass

    @abstractmethod
    def delete(self, product_id):
        pass

    @abstractmethod
    def update(self, product_id, **kwargs):
        pass

    @abstractmethod
    def get_page(self, page=1, page_size=3):
        pass

    @abstractmethod
    def get_all(self):
        pass