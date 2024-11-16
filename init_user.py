import datetime
import json
import random
import pandas as pd
from faker import Faker

fake = Faker()

def generate_mock_user():
    # current_time = datetime.datetime.now()

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

    user = {
        'user_id': user_id,
        'citizen_id': citizen_id,
        'gender': gender,
        'address': fake.address(),
        'phone_number': "".join([str(random.randint(0, 9)) for _ in range(10)]),
        'display_name': fake.user_name(),
        'picture_link': fake.image_url(),
        'description': "".join(fake.random_letters(20)),
        'user_type': "Both",
    }

    citizen = {
        'citizen_id': citizen_id,
        'first_name': first_name,
        'middle_name': mid_name,
        'last_name': last_name,
    }

    min_price = random.randint(1, 1000)

    buddy = {
        'buddy_id': user_id,
        'withdrawable_coin_amount': random.randint(50, 1000),
        'average_rating': round(random.random() * 5, 5),
        'min_price': min_price,
        'max_price': min_price + random.randint(100, 1500),
    }

    min_price = random.randint(1, 1000)

    customer = {
        'customer_id': user_id,
        'coin_amount': random.randint(50, 1000),
        'gender': user["gender"],
        'age': random.randint(15, 45),
        'location': fake.location_on_land()[-1],
        'min_price': min_price,
        'max_price': min_price + random.randint(100, 1500),
    }

    return {
        "user": user,
        "citizen": citizen,
        "buddy": buddy,
        "customer": customer,
    }

def generate_batches_user(num: int):
    return [generate_mock_user() for _ in range(num)]

def save_to_csv(data, base_filename="mock_data"):

    user_data = [entry["user"] for entry in data]
    citizen_data = [entry["citizen"] for entry in data]
    buddy_data = [entry["buddy"] for entry in data]
    customer_data = [entry["customer"] for entry in data]

    pd.DataFrame(user_data).to_csv(f"./data/{base_filename}_user.csv", index=False, header=False)
    print("Data saved to separate CSV files.")
    pd.DataFrame(citizen_data).to_csv(f"./data/{base_filename}_citizen.csv", index=False, header=False)
    print("Data saved to separate CSV files.")
    pd.DataFrame(buddy_data).to_csv(f"./data/{base_filename}_buddy.csv", index=False, header=False)
    print("Data saved to separate CSV files.")
    pd.DataFrame(customer_data).to_csv(f"./data/{base_filename}_customer.csv", index=False, header=False)
    print("Data saved to separate CSV files.")

if __name__ == "__main__":
    mockUsers = generate_batches_user(500)
    save_to_csv(mockUsers, base_filename="mock_data")