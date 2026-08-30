import pandas as pd
from pathlib import Path
from sqlalchemy import create_engine

# ============================================================
# OLIST E-COMMERCE BI — CSV TO MYSQL LOADER
# ============================================================

# Project folders
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "Data"

# MySQL connection
DB_USER = "Your user"
DB_PASSWORD = "Your Password"
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "olist_bi"

engine = create_engine(
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# CSV file -> MySQL table
tables = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation"
}

# Date columns that should be stored as MySQL DATETIME
date_columns = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ],
    "order_reviews": [
        "review_creation_date",
        "review_answer_timestamp"
    ]
}

print("=" * 70)
print("OLIST E-COMMERCE DATA LOADING")
print("=" * 70)

for csv_file, table_name in tables.items():

    file_path = DATA_DIR / csv_file

    print("\n" + "-" * 70)
    print(f"Loading: {csv_file}")
    print(f"MySQL table: {table_name}")
    print("-" * 70)

    # Read CSV
    df = pd.read_csv(file_path)

    # Convert date columns
    if table_name in date_columns:
        for column in date_columns[table_name]:
            if column in df.columns:
                df[column] = pd.to_datetime(
                    df[column],
                    errors="coerce"
                )

    print(f"Rows read: {len(df):,}")
    print(f"Columns: {len(df.columns)}")

    # Load into MySQL
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="replace",
        index=False,
        chunksize=5000,
        method="multi"
    )

    print(f"SUCCESS: {table_name}")

print("\n" + "=" * 70)
print("ALL OLIST TABLES LOADED SUCCESSFULLY")
print("=" * 70)
