import random
import json
import pandas as pd
from faker import Faker

fake = Faker()

def save_to_csv(data, table_name, base_filename="mock_data"):
    pd.DataFrame(data).to_csv(f"./data/{base_filename}_{table_name}.csv", index=False, header=False)
    print(f"Data saved to ./data/{base_filename}_{table_name}.csv")

if __name__ == "__main__":
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
    service_types = { 
        "type_id": [i+1 for i in range(len(service_types))],
        "description": service_types
    }
    save_to_csv(service_types, "service_type")