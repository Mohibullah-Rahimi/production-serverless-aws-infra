import os
import ssl
import pg8000

DB_HOST = os.environ["DB_HOST"]
DB_NAME = os.environ["DB_NAME"]
DB_USER = os.environ["DB_USER"]
DB_PASSWORD = os.environ["DB_PASSWORD"]
DB_PORT = int(os.environ.get("DB_PORT", "5432"))

# Enable SSL/TLS for RDS PostgreSQL
ssl_context = ssl.create_default_context()


def get_connection():
    return pg8000.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        ssl_context=ssl_context   # IMPORTANT FIX
    )
