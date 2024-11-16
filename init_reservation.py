"""
create mock 
"""

import datetime
import random
import json
import pandas as pd
from faker import Faker

users_df = pd.read_csv("./data/mock_data_user.csv").values
userIds = list(users_df[:, 0])

fake = Faker()

def generate_mock_reservation():

    customer_id = random.choice(userIds)
    buddy_id = random.choice(userIds)

    while(buddy_id == customer_id):
        buddy_id = random.choice(userIds)

    # reservation_record
    reservation = {
        'reservation_id': fake.uuid4(),
        'price_coin': random.randint(15, 50) * 100,
        'reservation_date':fake.date(),
        'status': "Complete",
        'create_timestamp': datetime.datetime.now().__str__(),
        'customer_id': customer_id,
        'buddy_id':buddy_id,
    }

    # service_record
    service = {
        'service_id': fake.uuid4(),
        'description': fake.text(max_nb_chars=40),
        'service_date': reservation['reservation_date'],
        'reservation_id': reservation['reservation_id'],
        'type_id': random.randint(1, 14), 
        'customer_id': customer_id,
        'buddy_id':buddy_id,
    }

    # coin transaction
    coin_transaction = {
        'transaction_id': fake.uuid4(),
        'fee_rate': 0.15,
        'transaction_status': "Complete",
        'timestamp': datetime.datetime.now().__str__(),
        'reservation_id': reservation['reservation_id'],
        'customer_id': customer_id,
        'buddy_id':buddy_id,
    }

    return reservation, service, coin_transaction

def generate_batches_reservation(num):

    reservations, services, coin_transactions = [], [], []

    for _ in range(num):
        reservation, service, coin_transaction = generate_mock_reservation()
        reservations.append(reservation)
        services.append(service)
        coin_transactions.append(coin_transaction)

    return reservations, services, coin_transactions

def save_to_csv(data, table_name, base_filename="mock_data"):
    pd.DataFrame(data).to_csv(f"./data/{base_filename}_{table_name}.csv", index=False, header=False)
    print(f"Data saved to ./data/{base_filename}_{table_name}.csv")

if __name__ == "__main__":
    # mock_reservation, mock_service, mock_transaction = generate_mock_reservation()
    # print(json.dumps(mock_reservation, indent=4))
    # print(json.dumps(mock_service, indent=4))
    # print(json.dumps(mock_transaction, indent=4))
    mock_reservations, mock_services, mock_transactions = generate_batches_reservation(80000)
    save_to_csv(mock_reservations, "reservation_record")
    save_to_csv(mock_services, "service_record")
    save_to_csv(mock_transactions, "coin_transaction")
