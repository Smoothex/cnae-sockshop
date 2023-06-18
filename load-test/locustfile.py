from uu import encode
import secrets
import string

from locust import HttpUser, TaskSet, task
from random import choice
import locust_plugins

class WebTasks(TaskSet):
##### CONSTANTS #####
    NUMBERS = 1
    LETTERS = 2

##### INITIATION OF OBJECT #####

    # The __init__ method is called, when an object is created from the class and initializes various attributes of the object (self)
    def __init__(self, parent):
        super().__init__(parent)
        self.user_id = ''
        self.username = self.generate_random_username()
        self.password = "password"
        self.email = self.username + "@test.com"
        self.card_details = self.generate_random_card()
        self.address_details = self.generate_random_address()

    # Generates random card in the according format using the helper function
    def generate_random_card(self):
        card = {
            "longNum": generate_random_id(16, self.NUMBERS),
            "expires": generate_random_id(2, self.NUMBERS) + "/" + generate_random_id(2, self.NUMBERS),
            "ccv": generate_random_id(3, self.NUMBERS),
        }
        return card

    # Generates random address in the according format using the helper function
    def generate_random_address(self):
        address = {
            "street": generate_random_id(10, self.LETTERS),
            "number": generate_random_id(3, self.NUMBERS),
            "country": generate_random_id(8, self.LETTERS),
            "city": generate_random_id(6, self.LETTERS),
            "postcode": generate_random_id(5, self.NUMBERS),
        }
        return address

    # Generates random username for each user
    def generate_random_username(self):
        return 'user{}'.format(generate_random_id(4, self.NUMBERS))

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
        response_json = response.json()  # From here to is only for test purposes
        id = response_json['id']
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
        response_json = response.json()  # From here to is only for test purposes
        id = response_json['id']
        print("Address ID:", id)

##### SCENARIO FUNCTIONS #####

    # This method is called when a new user (virtual user) starts running
    def on_start(self):
        self.user_id = self.register()
        print('Username: {}'.format(self.username))
        
        self.create_card()
        self.create_address()

        # Add the userID as a property of the card and address
        self.card_details.update({"userID" : self.user_id})
        self.address_details.update({"userID" : self.user_id})

    # Defines the user's behavior or actions that are repeated during load testing or performance testing.
    @task
    def load(self):
        # Chooses 3 prdoucts from the catalogue
        catalogue = self.client.get('/catalogue').json()
        id_item1 = choose_element_from_catalogue(catalogue)
        id_item2, price_item2 = choose_element_from_catalogue(catalogue)
        id_item3, price_item3 = choose_element_from_catalogue(catalogue)

        # Logs into the account 
        self.client.get('/')
        self.client.get("/login", auth=(self.username, self.password))

        # Looks at details of the first two items
        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(id_item1))
        self.client.get('/detail.html?id={}'.format(id_item2))
        
        # Adds some amount of the second prduct to the cart
        amount_item2 = 1
        self.client.post('/cart', json={'id': id_item2, 'quantity': amount_item2})

        # Looks at a third product and adds such amount of it so that the order can get through (budget is only 100$)
        self.client.get('/category.html')
        self.client.get('/detail.html?id={}'.format(id_item3))
        amount_item3 = generate_amount_for_product_to_add(amount_item2, price_item2, price_item3)
        self.client.post('/cart', json={'id': id_item3, 'quantity': amount_item3})

        # Goes to the cart and pruchases the products
        self.client.get('/basket.html')
        self.client.post('/orders')

    # This method is called when the user (virtual user) stops running
    def on_stop(self):
        self.client.delete('/customers/{}'.format(self.user_id))

##### HELPER FUNCTIONS #####

# Generates random IDs (either numbers only, letters only or hexadecimal string)
def generate_random_id(length, output_type):
    if output_type == 1:
        characters = string.digits
    elif output_type == 2:
        characters = string.ascii_letters
    else:
        characters = string.hexdigits[:-6]  # Exclude letters a-f for mixed hex string

    random_id = ''.join(secrets.choice(characters) for _ in range(length))
    return random_id

# Chooses a random element from the catalogue, deletes the product from the list and returns its id and price
def choose_element_from_catalogue(catalogue):
    item = choice(catalogue)
    price = item['price']
    
    if (price == 99.99):
        catalogue.remove(item)
        item = choice(catalogue)
        price = item['price']

    id = item['id']
    catalogue.remove(item)
    return id, price

# Generates the amount of a product we can add to the cart given the amount of the already added product and both products' prices
def generate_amount_for_product_to_add(amount_item_cart, price_item_cart, price_item_to_add):
    delivery = 5
    budget_left = 100 - delivery - (amount_item_cart * price_item_cart)
    amount_item_to_add = 0
    
    while (amount_item_to_add + 1) * price_item_to_add <= budget_left:
        amount_item_to_add += 1

    return amount_item_to_add

class Web(HttpUser):
    tasks = [WebTasks]
    min_wait = 0
    max_wait = 0
