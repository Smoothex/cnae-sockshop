import base64
from uu import encode

from locust import HttpUser, TaskSet, task
from random import randint, choice
import locust_plugins


class WebTasks(TaskSet):

    @task
    def load(self):

        catalogue = self.client.get('/catalogue').json()
        category_item1 = choice(catalogue)
        item_id1 = category_item1['id']

        category_item2 = choice(catalogue)
        item_id2 = category_item2['id']

        category_item3 = choice(catalogue)
        item_id3 = category_item3['id']

        self.client.get('/')
        self.client.get("/login", auth=('user', 'password'))

        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(item_id1))
        self.client.get('/detail.html?id={}'.format(item_id2))

        self.client.post('/cart', json={'id': item_id2, 'quantity': 1})
        
        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(item_id1))
        self.client.post('/cart', json={'id': item_id3, 'quantity': 2})

        self.client.get('/basket.html')
        self.client.post('/orders')


class Web(HttpUser):
    tasks = [WebTasks]
    min_wait = 0
    max_wait = 0
