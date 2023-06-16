import base64
from uu import encode
import secrets
import string

from locust import HttpUser, TaskSet, task
from random import randint, choice
import locust_plugins

class WebTasks(TaskSet):
    # the __init__ method is called, when an object is created from the class and initializes various attributes of the object (self)
    def __init__(self, parent):
        super().__init__(parent)
        self.username = "user18"     #  TODO create a user with a random name every time, so that the load test is better scalable
        self.password = "password"
        self.email = self.username + "@test.com"
        self.card_details = self.generate_random_card()
        self.address_details = self.generate_random_address()

    # Generate random card in the according format using the helper function
    def generate_random_card(self):
        card = {
            "longNum": generate_random_id(16, "numbers"),
            "expires": generate_random_id(2, "numbers") + "/" + generate_random_id(2, "numbers"),
            "ccv": generate_random_id(3, "numbers"),
        }
        return card

    # Generate random address in the according format using the helper function
    def generate_random_address(self):
        address = {
            "street": generate_random_id(10, "letters"),
            "number": generate_random_id(3, "numbers"),
            "country": generate_random_id(8, "letters"),
            "city": generate_random_id(6, "letters"),
            "postcode": generate_random_id(5, "numbers"),
        }
        return address

    # This method is called when a new user (virtual user) starts running
    def on_start(self):
        userID = self.register()
        self.create_card()
        self.create_address()

        # Add the userID as a property of the card and address
        self.card_details.update({"userID" : userID})
        self.address_details.update({"userID" : userID})
        
        #print(self.card_details)
        #print(self.address_details)


    # Registers the user
    def register(self):
        register_payload = {
            "username": self.username,
            "password": self.password,
            "email": self.email,
        }
        # execute the POST request and get the user id, so we can assign it to card_details and address_details
        response = self.client.post("/register", json=register_payload)
        response_json = response.json()
        id = response_json.get("id")
        return id
        

    # Creates a card for the user
    def create_card(self):
        card_payload = {
            "longNum": self.card_details["longNum"],
            "expires": self.card_details["expires"],
            "ccv": self.card_details["ccv"],
        }
        response = self.client.post("/cards", json=card_payload)
        response_json = response.json()
        id = response_json.get("id")
        print("Card ID:", id)
        

    # Adds an address to the current user
    def create_address(self):
        address_payload = {
            "street": self.address_details["street"],
            "number": self.address_details["number"],
            "country": self.address_details["country"],
            "city": self.address_details["city"],
            "postcode": self.address_details["postcode"],
        }
        response = self.client.post("/addresses", json=address_payload)
        response_json = response.json()
        id = response_json.get("id")
        print("Address ID:", id)


    # Defines the user's behavior or actions that are repeated during load testing or performance testing.
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
        #self.client.get("/login", auth=(self.username, self.password))

        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(item_id1))
        self.client.get('/detail.html?id={}'.format(item_id2))

        self.client.post('/cart', json={'id': item_id2, 'quantity': 1})

        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(item_id1))
        self.client.post('/cart', json={'id': item_id3, 'quantity': 2})

        # Commented these 2 lines out, because I wanted to only test the creation of a user with a card and an address, feel free to comment back in
        #self.client.get('/basket.html')
        #self.client.post('/orders')

# Helper function that generates random IDs (either numbers only, letters only)
def generate_random_id(length, output_type):
    if output_type == "numbers":
        characters = string.digits
    elif output_type == "letters":
        characters = string.ascii_letters
    else:
        characters = string.hexdigits[:-6]  # Exclude letters a-f for mixed hex string
    
    random_id = ''.join(secrets.choice(characters) for _ in range(length))
    return random_id

class Web(HttpUser):
    tasks = [WebTasks]
    min_wait = 0
    max_wait = 0
