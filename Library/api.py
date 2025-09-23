import requests
import random
import datetime
import calendar

def get_random_users():
    response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
    print(response.json)
    return response.json()

def random_birthday(start_year=1950, end_year=2010):
    year = random.randint(start_year, end_year)
    month = random.randint(1, 12)
    day = random.randint(1, calendar.monthrange(year, month)[1])
    birthday = datetime.date(year % 10000, month, day)
    return birthday.strftime("%Y-%m-%d")
 