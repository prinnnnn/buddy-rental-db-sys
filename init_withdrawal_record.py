import datetime
import random
import json
import pandas as pd
from faker import Faker
import faker as f

users_df = pd.read_csv("./data/mock_data_user.csv").values
user_ids = list(users_df[:, 0])

fake = Faker()

adjectives = ["First", "National", "Global", "United", "Secure", "Premier", "Elite"]
nouns = ["Bank", "Trust", "Financial", "Savings", "Credit Union", "Capital", "Reserve"]
locations = ["of America", "of Europe", "of Asia", "of the Pacific", "Worldwide", "Corporation"]

def generate_bank_name():
    adj = random.choice(adjectives)
    noun = random.choice(nouns)
    loc = random.choice(locations) if random.random() > 0.5 else ""
    return f"{adj} {noun} {loc}".strip()

def generate_mock_reservation():

    buddy_id = random.choice(user_ids)

    withdraw_record = {
        'withdraw_id': fake.uuid4(),
        'bank_information': generate_bank_name(),
        'exchange_rate': 0.9,
        'coin_amount': random.randint(10, 500),
        'timestamp': datetime.datetime.now().__str__(),
        'buddy_id':buddy_id,
    }

    return withdraw_record

def generate_batches_withdraw_record(num):
    return [generate_mock_reservation() for _ in range(num)]

def save_to_csv(data, table_name, base_filename="mock_data"):
    pd.DataFrame(data).to_csv(f"./data/{base_filename}_{table_name}.csv", index=False, header=False)
    print(f"Data saved to ./data/{base_filename}_{table_name}.csv")

if __name__ == "__main__":
    mock_withdraw_records = generate_batches_withdraw_record(4000)
    save_to_csv(mock_withdraw_records, "withdrawal_record")