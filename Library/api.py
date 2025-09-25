import requests
import random

user_count = 5
def get_five_users(page=1):
    response = requests.get(f"https://jsonplaceholder.typicode.com/users?_limit={user_count}&_page={page}", verify=False)
    print(response.json)
    return response.json()


def random_birthday():
    month = str(random.randint(1, 12)).zfill(2)
    day = str(random.randint(1, 28)).zfill(2)
    year = str(random.randint(1950, 2020)).zfill(4)
    return month + "-" + day + "-" + year

def normalize_birthday(val):
    parts = val.split('-')
    year, month, day = parts[0], parts[1], parts[2]
    return f"{month}-{day}-{year}"