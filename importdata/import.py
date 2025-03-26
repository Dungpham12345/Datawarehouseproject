import pyodbc
import pandas as pd
from datetime import datetime

# Establish connection to SQL Server
conn = pyodbc.connect(
    "DRIVER=SQL Server;"
    "SERVER=dngptm-server.database.windows.net;"
    "DATABASE=dngptm-db;"
    "UID=dngptm;"
    "PWD=Cntt@1234;"
)

cursor = conn.cursor()

def convert_to_utc(date_str):
    try:
        local_time = datetime.strptime(date_str[:-3], '%Y-%m-%d %H:%M:%S')  # Cắt bỏ múi giờ
        offset_hours = int(date_str[-3:])  # Lấy múi giờ
        utc_time = local_time - pd.Timedelta(hours=offset_hours)
        return utc_time.strftime('%Y-%m-%d %H:%M:%S')
    except ValueError:
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Giá trị mặc định nếu có lỗi

# df['last_update'] = df['last_update'].astype(str).apply(convert_to_utc)


# # Function to insert data into a table
# def insert_data(table_name, csv_file, query, columns):
#     df = pd.read_csv(csv_file)  # Load CSV
#     for index, row in df.iterrows():
#         try:
#             cursor.execute(query, [row[col] for col in columns])
#             conn.commit()
#             print(f"Inserted successfully into {table_name}: {row.to_dict()}")
#         except Exception as e:
#             print(f"Error inserting into {table_name}, row {index}: {e}")

from datetime import datetime

# Function to insert data into a table
def insert_data(table_name, csv_file, query, columns):
    df = pd.read_csv(csv_file)  # Load CSV

    for index, row in df.iterrows():
        try:
            values = []
            for col in columns:
                value = row[col]


                if table_name == "ADDRESS" and col not in ("address_id","city_id","last_update"):
                    value = str(value)

                # Nếu là cột datetime, chuẩn hóa định dạng
                if "date" in col or "last_update" in col:  
                    try:
                        # value = datetime.strptime(value, "%Y-%m-%d %H:%M:%S%z").strftime("%Y-%m-%d %H:%M:%S")
                        value = convert_to_utc(value)
                    except Exception as e:
                        print(f"Lỗi chuyển đổi datetime cho {col} tại dòng {index}: {e}")
                # print(value, type(value))
                values.append(value)

            cursor.execute(query, values)
            conn.commit()
            print(f"Inserted successfully into {table_name}: {row.to_dict()}")
        except Exception as e:
            print(f"Error inserting into {table_name}, row {index}: {e}")

# Định nghĩa query INSERT cho các bảng
tables = {
    # "COUNTRY": {
    #     "csv": "archive/country.csv",
    #     "query": """
    #         SET IDENTITY_INSERT country ON;
    #         INSERT INTO country (country_id, country, last_update)
    #         VALUES (?, ?, ?)
    #     """,
    #     "columns": ["country_id", "country", "last_update"]
    # },
    # "CITY": {
    #     "csv": "archive/city.csv",
    #     "query": """
    #         SET IDENTITY_INSERT country OFF;
    #         SET IDENTITY_INSERT city ON;
    #         INSERT INTO city (city_id, city, country_id, last_update)
    #         VALUES (?, ?, ?, ?)
    #     """,
    #     "columns": ["city_id", "city", "country_id", "last_update"]
    # },
    # "ADDRESS": {
    #     "csv": "archive/address.csv",
    #     "query": """
    #         SET IDENTITY_INSERT city OFF;
    #         SET IDENTITY_INSERT address ON;
    #         INSERT INTO address (address_id, address, address2, district, city_id, postal_code, phone, last_update)
    #         VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    #     """,
    #     "columns": ["address_id", "address", "address2", "district", "city_id", "postal_code", "phone", "last_update"]
    # }
    # ,
    # "LANGUAGE": {
    #     "csv": "archive/language.csv",
    #     "query": """
    #         SET IDENTITY_INSERT address OFF;
    #         SET IDENTITY_INSERT language ON;
    #         INSERT INTO language (language_id, name, last_update)
    #         VALUES (?, ?, ?)
    #     """,
    #     "columns": ["language_id", "name", "last_update"]
    # }
    # ,
    # "STORE": {
    #     "csv": "archive/store.csv",
    #     "query": """
    #         SET IDENTITY_INSERT staff OFF;
    #         SET IDENTITY_INSERT store ON;
    #         INSERT INTO store (store_id, manager_staff_id, address_id, last_update)
    #         VALUES (?, ?, ?, ?)
    #     """,
    #     "columns": ["store_id", "manager_staff_id", "address_id", "last_update"]
    # },
    # "STAFF": {
    #     "csv": "archive/staff.csv",
    #     "query": """
    #         SET IDENTITY_INSERT language OFF;
    #         SET IDENTITY_INSERT staff ON;
    #         INSERT INTO staff (staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update)
    #         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    #     """,
    #     "columns": ["staff_id", "first_name", "last_name", "address_id", "email", "store_id", "active", "username", "password", "last_update"]
    # }
    # ,

    # "CUSTOMER": {
    #     "csv": "archive/customer.csv",
    #     "query": """
    #         SET IDENTITY_INSERT store OFF;
    #         SET IDENTITY_INSERT customer ON;
    #         INSERT INTO customer (customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
    #         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    #     """,
    #     "columns": ["customer_id", "store_id", "first_name", "last_name", "email", "address_id", "active", "create_date", "last_update"]
    # }
    # ,
    # "FILM": {
    #     "csv": "archive/film.csv",
    #     "query": """
    #         SET IDENTITY_INSERT customer OFF;
    #         SET IDENTITY_INSERT film ON;
    #         INSERT INTO film (film_id, title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, last_update)
    #         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    #     """,
    #     "columns": ["film_id", "title", "description", "release_year", "language_id", "rental_duration", "rental_rate", "length", "replacement_cost", "rating", "last_update"]
    # }
    # ,
    # "ACTOR": {
    #     "csv": "archive/actor.csv",
    #     "query": """
    #         SET IDENTITY_INSERT film OFF;
    #         SET IDENTITY_INSERT actor ON;
    #         INSERT INTO actor (actor_id, first_name, last_name, last_update)
    #         VALUES (?, ?, ?, ?)
    #     """,
    #     "columns": ["actor_id", "first_name", "last_name", "last_update"]
    # }
    # # ,
    # "CATEGORY": {
    #     "csv": "archive/category.csv",
    #     "query": """
    #         SET IDENTITY_INSERT actor OFF;
    #         SET IDENTITY_INSERT category ON;
    #         INSERT INTO category (category_id, name, last_update)
    #         VALUES (?, ?, ?)
    #     """,
    #     "columns": ["category_id", "name", "last_update"]
    # }
    # ,
    # "FILM_ACTOR": {
    #     "csv": "archive/film_actor.csv",
    #     "query": """
    #         INSERT INTO film_actor (actor_id, film_id, last_update)
    #         VALUES (?, ?, ?)
    #     """,
    #     "columns": ["actor_id", "film_id", "last_update"]
    # }
    # ,
    # "FILM_CATEGORY": {
    #     "csv": "archive/film_category.csv",
    #     "query": """
    #         INSERT INTO film_category (film_id, category_id, last_update)
    #         VALUES (?, ?, ?)
    #     """,
    #     "columns": ["film_id", "category_id", "last_update"]
    # }
    # ,
    # "INVENTORY": {
    #     "csv": "archive/inventory.csv",
    #     "query": """
    #         SET IDENTITY_INSERT category OFF;
    #         SET IDENTITY_INSERT inventory ON;
    #         INSERT INTO inventory (inventory_id, film_id, store_id, last_update)
    #         VALUES (?, ?, ?, ?)
    #     """,
    #     "columns": ["inventory_id", "film_id", "store_id", "last_update"]
    # }
    # ,
    "RENTAL": {
        "csv": "archive/rental.csv",
        "query": """
            SET IDENTITY_INSERT inventory OFF;
            SET IDENTITY_INSERT rental ON;
            INSERT INTO rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        "columns": ["rental_id", "rental_date", "inventory_id", "customer_id", "return_date", "staff_id", "last_update"]
    }
    # ,
    # "PAYMENT": {
    #     "csv": "archive/payment.csv",
    #     "query": """
    #         SET IDENTITY_INSERT rental OFF;
    #         SET IDENTITY_INSERT payment ON;
    #         INSERT INTO payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update)
    #         VALUES (?, ?, ?, ?, ?, ?, ?)
    #     """,
    #     "columns": ["payment_id", "customer_id", "staff_id", "rental_id", "amount", "payment_date", "last_update"]
    # }
}


# Insert data into each table
for table, info in tables.items():
    print(f"Inserting data into {table}...")
    insert_data(table, info["csv"], info["query"], info["columns"])

# Close connection
cursor.close()
conn.close()
print("Data insertion completed!")