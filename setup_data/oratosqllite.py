import oracledb
import sqlite3
import getpass
import json
import re

def get_oracle_connection():
    hostname = input("Enter Oracle hostname: ")
    username = input("Enter Oracle username: ")
    password = getpass.getpass("Enter Oracle password: ")
    port = input("Enter Oracle port (default: 1521): ") or "1521"
    service_name = input("Enter Oracle service name: ")
    
    dsn = f"{hostname}:{port}/{service_name}"
    
    try:
        connection = oracledb.connect(user=username, password=password, dsn=dsn)
        print("Connected to Oracle successfully!")
        return connection
    except oracledb.DatabaseError as e:
        print(f"Error connecting to Oracle: {e}")
        return None

def get_sqlite_connection():
    db_path = input("Enter SQLite database path and filename: ")
    try:
        connection = sqlite3.connect(db_path)
        print("Connected to SQLite successfully!")
        return connection
    except sqlite3.Error as e:
        print(f"Error connecting to SQLite: {e}")
        return None

def list_oracle_objects(connection, converted_objects):
    cursor = connection.cursor()
    cursor.execute("SELECT table_name, 'TABLE' FROM user_tables UNION SELECT view_name, 'VIEW' FROM user_views")
    objects = [(row[0], row[1]) for row in cursor.fetchall()]
    cursor.close()
    
    if not objects:
        print("No tables or views found in the schema.")
        return []
    
    print("Tables and Views in Oracle schema:")
    for idx, obj in enumerate(objects, 1):
        status = "[Converted]" if obj[0] in converted_objects else ""
        print(f"{idx}. {obj[0]} ({obj[1]}) {status}")
    
    return objects

def get_column_types(oracle_cursor, object_name):
    oracle_cursor.execute(f"SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '{object_name}'")
    type_mapping = {
        "NUMBER": "REAL",
        "VARCHAR2": "TEXT",
        "CHAR": "TEXT",
        "DATE": "TEXT",
        "TIMESTAMP": "TEXT",
        "CLOB": "TEXT",
        "BLOB": "BLOB",
        "JSON": "TEXT"
    }
    return [(col[0], type_mapping.get(col[1], "TEXT")) for col in oracle_cursor.fetchall()]

def get_view_definition(oracle_cursor, view_name):
    oracle_cursor.execute(f"SELECT text FROM user_views WHERE view_name = '{view_name}'")
    row = oracle_cursor.fetchone()
    if not row:
        return None
    
    view_definition = row[0]
    
    # Remove Oracle-specific SQL constructs
    view_definition = re.sub(r"\bFROM\s+DUAL\b", "", view_definition, flags=re.IGNORECASE)
    view_definition = re.sub(r"\bCONNECT\s+BY\b.*", "", view_definition, flags=re.IGNORECASE)
    
    return view_definition

def transfer_object(oracle_conn, sqlite_conn, object_name, object_type, converted_objects):
    oracle_cursor = oracle_conn.cursor()
    sqlite_cursor = sqlite_conn.cursor()
    
    sqlite_cursor.execute("SELECT name FROM sqlite_master WHERE type IN ('table', 'view') AND name=?", (object_name,))
    exists = sqlite_cursor.fetchone()
    
    if not exists:
        if object_type == 'TABLE':
            print(f"Table {object_name} does not exist in SQLite. Creating it...")
            columns = get_column_types(oracle_cursor, object_name)
            create_table_sql = f"CREATE TABLE {object_name} (" + ", ".join([f'{col} {dtype}' for col, dtype in columns]) + ")"
            sqlite_cursor.execute(create_table_sql)
            sqlite_conn.commit()
        elif object_type == 'VIEW':
            print(f"View {object_name} does not exist in SQLite. Creating it...")
            view_definition = get_view_definition(oracle_cursor, object_name)
            if view_definition:
                try:
                    sqlite_cursor.execute(f"CREATE VIEW {object_name} AS {view_definition}")
                    sqlite_conn.commit()
                except sqlite3.OperationalError as e:
                    print(f"Error creating view {object_name}: {e}")
            else:
                print(f"Could not retrieve definition for view {object_name}. Skipping creation.")
                return
    
    if object_type == 'TABLE':
        print(f"Transferring data from Oracle table {object_name} to SQLite...")
        oracle_cursor.execute(f"SELECT * FROM {object_name}")
        rows = oracle_cursor.fetchall()
        column_desc = oracle_cursor.description
        
        formatted_rows = []
        for row in rows:
            formatted_row = []
            for value, col_desc in zip(row, column_desc):
                if isinstance(value, dict):  # Handle JSON columns
                    formatted_row.append(json.dumps(value))
                elif isinstance(value, oracledb.Timestamp):  # Handle TIMESTAMP columns
                    formatted_row.append(value.strftime("%Y-%m-%d %H:%M:%S"))
                else:
                    formatted_row.append(value)
            formatted_rows.append(tuple(formatted_row))
        
        placeholders = ', '.join(['?' for _ in column_desc])
        insert_sql = f"INSERT INTO {object_name} VALUES ({placeholders})"
        
        sqlite_cursor.executemany(insert_sql, formatted_rows)
        sqlite_conn.commit()
        print(f"Data transfer complete for table {object_name}.")
    
    converted_objects.add(object_name)
    oracle_cursor.close()
    sqlite_cursor.close()

def main():
    oracle_conn = get_oracle_connection()
    if not oracle_conn:
        return
    
    sqlite_conn = get_sqlite_connection()
    if not sqlite_conn:
        return
    
    converted_objects = set()
    
    while True:
        objects = list_oracle_objects(oracle_conn, converted_objects)
        if not objects:
            return
        
        try:
            choice = input("Enter the number of the table/view to transfer (or 'N' to quit): ")
            if choice.upper() == 'N':
                break
            choice = int(choice)
            if 1 <= choice <= len(objects):
                transfer_object(oracle_conn, sqlite_conn, objects[choice - 1][0], objects[choice - 1][1], converted_objects)
            else:
                print("Invalid choice.")
        except ValueError:
            print("Invalid input. Please enter a number or 'N' to quit.")
    
    oracle_conn.close()
    sqlite_conn.close()
    print("Connections closed.")

if __name__ == "__main__":
    main()
