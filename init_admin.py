# CREATE TABLE ADMIN (
#     admin_id VARCHAR(32) PRIMARY KEY,
#     first_name VARCHAR(32) NOT NULL,
#     middle_name VARCHAR(32),
#     last_name VARCHAR(32) NOT NULL
# );

import json
import pandas as pd
from faker import Faker

fake = Faker()

def generate_mock_admin():

    full_name = fake.name_nonbinary().split(" ")

    return {
        "admin_id": fake.uuid4(),
        "first_name": full_name[0],
        "middle_name": "X",
        "last_name": full_name[1],
    }

def generate_batches_admin(num: int):
    return [generate_mock_admin() for _ in range(num)]

def save_to_csv(data, base_filename="mock_data"):
    pd.DataFrame(data).to_csv(f"./data/{base_filename}_admin.csv", index=False, header=False)

if __name__ == "__main__":
    # mockAdmin = generate_mock_admin()
    mockAdmins = generate_batches_admin(1000)
    save_to_csv(mockAdmins)