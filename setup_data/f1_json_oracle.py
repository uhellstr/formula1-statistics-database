import sqlite3
import oracledb
import os
import getpass
from datetime import datetime

def get_sqlite_connection():
    db_path = input("Enter the SQLite database path and filename: ")
    if not os.path.exists(db_path):
        print("Error: SQLite database not found at the given path.")
        exit(1)
    try:
        conn = sqlite3.connect(db_path)
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to SQLite database: {e}")
        exit(1)

def check_table_exists_sqlite(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='F1_JSON_DOCS';")
    table = cursor.fetchone()
    if not table:
        print("Error: Table 'F1_JSON_DOCS' does not exist in the SQLite database.")
        exit(1)
    return cursor

def get_oracle_connection():
    hostname = input("Enter the Oracle hostname: ")
    username = input("Enter the Oracle username: ")
    password = getpass.getpass("Enter the Oracle password: ")
    port = input("Enter the Oracle listener port (default 1521): ") or "1521"
    service_name = input("Enter the Oracle SERVICE_NAME: ")
    dsn = f"{hostname}:{port}/{service_name}"
    
    try:
        conn = oracledb.connect(user=username, password=password, dsn=dsn)
        cursor = conn.cursor()
        
        # Set NLS session parameters individually
        cursor.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'RRRR-MM-DD HH24:MI:SS'")
        cursor.execute("ALTER SESSION SET NLS_DATE_LANGUAGE = 'SWEDISH'")
        cursor.execute("ALTER SESSION SET NLS_SORT = 'SWEDISH'")
        cursor.execute("ALTER SESSION SET NLS_TIME_FORMAT = 'HH24:MI:SSXFF'")
        cursor.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'RRRR-MM-DD HH24:MI:SSXFF'")
        cursor.execute("ALTER SESSION SET NLS_TIME_TZ_FORMAT = 'HH24:MI:SSXFF TZR'")
        cursor.execute("ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'RRRR-MM-DD HH24:MI:SSXFF TZR'")
        
        return conn
    except oracledb.DatabaseError as e:
        print(f"Error connecting to Oracle database: {e}")
        exit(1)

def check_table_exists_oracle(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT column_name, data_type FROM user_tab_columns WHERE table_name = 'F1_JSON_DOCS'")
    columns = {row[0]: row[1] for row in cursor.fetchall()}
    if not columns:
        print("Error: Table 'F1_JSON_DOCS' does not exist in the Oracle database.")
        exit(1)
    return columns

def migrate_data(sqlite_conn, oracle_conn, oracle_columns):
    sqlite_cursor = sqlite_conn.cursor()
    oracle_cursor = oracle_conn.cursor()
    
    try:
        
        delete_sql = f"DELETE FROM F1_JSON_DOCS"
        oracle_cursor.execute(delete_sql)
        oracle_conn.commit()
        
        sqlite_cursor.execute("SELECT * FROM F1_JSON_DOCS")
        rows = sqlite_cursor.fetchall()
        
        columns = [desc[0] for desc in sqlite_cursor.description]
        column_names = ', '.join(columns)
        placeholders = ', '.join([':' + str(i+1) for i in range(len(columns))])
        
        formatted_rows = []
        for row in rows:
            row = list(row)
            for i, col_name in enumerate(columns):
                if col_name in oracle_columns:
                    if oracle_columns[col_name] in ('NUMBER', 'FLOAT'):
                        row[i] = float(row[i]) if row[i] is not None else None
                    elif oracle_columns[col_name] == 'DATE':
                        row[i] = datetime.strptime(row[i], '%Y-%m-%d %H:%M:%S') if row[i] is not None else None
                    elif oracle_columns[col_name] == 'TIMESTAMP':
                        row[i] = datetime.strptime(row[i], '%Y-%m-%d %H:%M:%S,%f') if row[i] is not None else None
            formatted_rows.append(tuple(row))
        
        insert_sql = f"INSERT INTO F1_JSON_DOCS ({column_names}) VALUES ({placeholders})"
        oracle_cursor.executemany(insert_sql, formatted_rows)
        oracle_conn.commit()
        print("Finished loading F1_JSON_DOCS.")
    except Exception as e:
        oracle_conn.rollback()
        print(f"Error during data migration: {e}")
        exit(1)

def main():
    sqlite_conn = get_sqlite_connection()
    check_table_exists_sqlite(sqlite_conn)
    
    oracle_conn = get_oracle_connection()
    oracle_columns = check_table_exists_oracle(oracle_conn)
    
    migrate_data(sqlite_conn, oracle_conn, oracle_columns)
    
    sqlite_conn.close()
    oracle_conn.close()
    
if __name__ == "__main__":
    main()

