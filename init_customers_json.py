import datetime
import json
import random
import pandas as pd
from faker import Faker

fake = Faker()

service_types = [
    "Sports",
    "Video games",
    "Board games",
    "Movie",
    "Hiking",
    "Volunteering",
    "Field trip",
    "Scooba diving",
    "Swimming",
    "Gardening",
    "Fishing",
    "Concerts",
    "Cooking",
    "Choirs"
]

buddy_tags = ["gaming", "chilling", "family", "friendly", "travel", "talkative"]

def generate_mock_buddy():
    current_time = datetime.datetime.now()

    user_id = fake.uuid4()
    citizen_id = "".join([str(random.randint(0, 9)) for _ in range(13)])
    gender = random.choice(["Male", "Female", "Other"])

    first_name, mid_name, last_name = None, None, None
    mid_name = fake.name_nonbinary().split(" ")[0]

    if gender == "Female":
        first_name = fake.first_name_female()
        last_name = fake.last_name_female()
    else:
        first_name = fake.first_name_male() 
        last_name = fake.last_name_male()

    num_services = random.randint(0, len(service_types))
    num_tags = random.randint(0, len(buddy_tags))
    min_price = random.randint(1, 1000)

    buddy = {
        'buddy_id': user_id,
        'citizen_id': citizen_id,
        'first_name': first_name,
        'middle_name': mid_name,
        'last_name': last_name,
        'gender': gender,
        'address': fake.address(),
        'phone_number': "".join([str(random.randint(0, 9)) for _ in range(10)]),
        'display_name': fake.user_name(),
        'picture_link': fake.image_url(),
        'description': "".join(fake.random_letters(20)),
        'buddy_id': user_id,
        'withdrawable_coin_amount': random.randint(50, 1000),
        'buddy_service_types': list(set(random.choices(service_types, k=num_services))),
        'buddy_tags': list(set(random.choices(buddy_tags, k=num_tags))),
        'average_rating': round(random.random() * 5, 5),
        'min_price': min_price,
        'max_price': min_price + random.randint(100, 1500),
    }

    return buddy

def generate_batches_buddies(num: int):
    return [generate_mock_buddy() for _ in range(num)]

if __name__ == "__main__":
    mockBuddies = generate_batches_buddies(100)
    # print(json.dumps(mockBuddies, indent=4))

    file_path = "./data/mock_buddy_mongo.json"
    with open(file_path, 'w') as file:
        file.write(json.dumps(mockBuddies, indent=4))

    print(f"Data saved successfully to {file_path}")