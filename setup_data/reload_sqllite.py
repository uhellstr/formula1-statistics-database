import oracledb
import sqlite3
import getpass
import sys
import json
from datetime import datetime, date

# Register adapters for datetime and date to avoid Python 3.12 deprecation warning
sqlite3.register_adapter(datetime, lambda d: d.isoformat())
sqlite3.register_adapter(date, lambda d: d.isoformat())

def prompt_oracle_connection():
    print("Enter Oracle database connection details:")
    hostname = input("Hostname: ")
    instance = input("Oracle instance name (SID): ")
    port = input("Listener port [1521]: ") or "1521"
    user = input("Username [F1_STAGING]: ") or "F1_STAGING"
    password = getpass.getpass("Password: ")

    dsn = f"{hostname}:{port}/{instance}"
    try:
        conn = oracledb.connect(user=user, password=password, dsn=dsn)
        print("✅ Oracle connection established.")
        return conn
    except oracledb.Error as e:
        print(f"❌ Oracle connection failed: {e}")
        sys.exit(1)

def prompt_sqlite_connection():
    sqlite_path = input("Enter path to SQLite database: ")
    try:
        conn = sqlite3.connect(sqlite_path)
        print("✅ SQLite connection established.")
        return conn
    except sqlite3.Error as e:
        print(f"❌ SQLite connection failed: {e}")
        sys.exit(1)

def verify_table_exists(conn, db_type):
    cursor = conn.cursor()
    if db_type == "oracle":
        cursor.execute("""
            SELECT table_name FROM user_tables WHERE table_name = 'F1_JSON_DOCS'
        """)
    elif db_type == "sqlite":
        cursor.execute("""
            SELECT name FROM sqlite_master WHERE type='table' AND name='F1_JSON_DOCS'
        """)
    else:
        raise ValueError("Unsupported DB type")

    exists = cursor.fetchone()
    cursor.close()
    return exists is not None

def transfer_data(oracle_conn, sqlite_conn):
    oracle_cursor = oracle_conn.cursor()
    sqlite_cursor = sqlite_conn.cursor()

    try:
        # Delete existing rows in SQLite
        sqlite_cursor.execute("DELETE FROM F1_JSON_DOCS")
        sqlite_conn.commit()

        # Fetch rows from Oracle
        oracle_cursor.execute("""
            SELECT * FROM F1_JSON_DOCS
            WHERE DOC_TYPE IN (1,2,3,4,5,6,7,8,9,10,11)
        """)
        rows = oracle_cursor.fetchall()
        columns = [desc[0] for desc in oracle_cursor.description]

        # Convert complex types to JSON strings where needed
        def convert_row(row):
            def convert_value(val):
                if isinstance(val, (dict, list)):
                    return json.dumps(val)
                else:
                    return val
            return [convert_value(v) for v in row]

        cleaned_rows = [convert_row(row) for row in rows]

        # Prepare INSERT for SQLite
        placeholders = ", ".join(["?"] * len(columns))
        insert_query = f"INSERT INTO F1_JSON_DOCS ({', '.join(columns)}) VALUES ({placeholders})"

        sqlite_cursor.executemany(insert_query, cleaned_rows)
        sqlite_conn.commit()

        print(f"✅ {len(cleaned_rows)} rows transferred to SQLite.")
    except Exception as e:
        print(f"❌ Error during data transfer: {e}")
        sys.exit(1)
    finally:
        oracle_cursor.close()
        sqlite_cursor.close()

def main():
    oracle_conn = prompt_oracle_connection()
    sqlite_conn = prompt_sqlite_connection()

    if not verify_table_exists(oracle_conn, "oracle"):
        print("❌ Table F1_JSON_DOCS does not exist in Oracle database.")
        sys.exit(1)

    if not verify_table_exists(sqlite_conn, "sqlite"):
        print("❌ Table F1_JSON_DOCS does not exist in SQLite database.")
        sys.exit(1)

    transfer_data(oracle_conn, sqlite_conn)

    oracle_conn.close()
    sqlite_conn.close()
    print("✅ Connections closed. All done!")

if __name__ == "__main__":
    main()
