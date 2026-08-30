from sqlalchemy import create_engine, text

engine = create_engine(
     f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@localhost:3306/olist_bi"
)

try:
    with engine.connect() as connection:
        result = connection.execute(text("SELECT DATABASE();"))
        database = result.fetchone()[0]

        print("=" * 50)
        print("MYSQL CONNECTION SUCCESSFUL")
        print("=" * 50)
        print(f"Database: {database}")

except Exception as e:
    print("MYSQL CONNECTION FAILED")
    print(e)
