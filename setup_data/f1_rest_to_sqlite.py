import os
import sqlite3
import requests
import json
from datetime import datetime
import urllib3

# Suppress insecure HTTPS warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Step 1: Ask for database path
db_path = input("Enter the path and name of the SQLite database file: ").strip()

# Step 2: Check if DB exists, if not create it
db_exists = os.path.exists(db_path)
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Step 3: Ensure F1_OFFICIAL_TIMEDATA and F1_OFFICIAL_WEATHER table exists
cursor.execute("""
CREATE TABLE IF NOT EXISTS F1_OFFICIAL_TIMEDATA (
    SEASON REAL, RACE REAL, RACETYPE TEXT, DATAPOINT REAL, TIME TEXT, DRIVER TEXT, 
    DRIVERNUMBER REAL, LAPTIME TEXT, LAPNUMBER REAL, STINT REAL, PITOUTTIME TEXT, 
    PITINTIME TEXT, SECTOR1TIME TEXT, SECTOR2TIME TEXT, SECTOR3TIME TEXT, 
    SECTOR1SESSIONTIME TEXT, SECTOR2SESSIONTIME TEXT, SECTOR3SESSIONTIME TEXT, 
    SPEEDI1 REAL, SPEEDI2 REAL, SPEEDFL REAL, SPEEDST REAL, ISPERSONALBEST TEXT, 
    COMPOUND TEXT, TYRELIFE REAL, FRESHTYRE TEXT, TEAM TEXT, LAPSTARTTIME TEXT, 
    LAPSTARTDATE TEXT, TRACKSTATUS REAL, POSITION REAL, DELETED TEXT, 
    DELETEDREASON TEXT, FATF1GENERATED TEXT, ISACCURATE TEXT
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS F1_OFFICIAL_WEATHER (
YEAR REAL, 
RACE REAL, 
RACETYPE TEXT, 
DATAPOINT REAL, 
TIME TEXT, 
AIRTEMP REAL, 
HUMIDITY REAL, 
PRESSURE REAL, 
RAINFALL TEXT, 
TRACKTEMP REAL, 
WINDDIRECTION REAL, 
WINDSPEED REAL
)
""")

# Step 4: Ensure F1_JSON_DOCTYPE table exists and has required row
cursor.execute("""
CREATE TABLE IF NOT EXISTS F1_JSON_DOCTYPE (
    ID REAL, DOC_TYPE TEXT
)
""")
cursor.execute("SELECT 1 FROM F1_JSON_DOCTYPE WHERE ID = 12 AND DOC_TYPE = 'F1_OFFICIAL_LAPTIMES'")
if cursor.fetchone() is None:
    cursor.execute("INSERT INTO F1_JSON_DOCTYPE (ID, DOC_TYPE) VALUES (?, ?)", (12, "F1_OFFICIAL_LAPTIMES"))
    conn.commit()

# Step 5: Ensure F1_JSON_DOCS table exists
cursor.execute("""
CREATE TABLE IF NOT EXISTS F1_JSON_DOCS (
    DOC_ID REAL, DOC_TYPE REAL, DATE_LOADED TEXT, 
    SEASON REAL, RACE REAL, LAPNUMBER REAL, 
    RACETYPE REAL, F1_DOCUMENT TEXT
)
""")

# Step 6: Delete any data in F1_JSON_DOCS with DOC_TYPE = 12
cursor.execute("DELETE FROM F1_JSON_DOCS WHERE DOC_TYPE = 12")
conn.commit()
print("Old data in F1_JSON_DOCS with DOC_TYPE = 12 has been deleted.")

# Step 7: Fetch data from REST API and insert into F1_JSON_DOCS
base_url = "https://fedora-oracle-linux--amd-lon1-01:8443/ords/f1_rest_access/f1_laptime_data/"
limit = 1000
offset = 0
doc_type = 12

while True:
    response = requests.get(base_url, params={'limit': limit, 'offset': offset}, verify=False)
    if response.status_code != 200:
        print(f"Failed to fetch data: {response.status_code}")
        break

    data = response.json()
    items = data.get("items", [])
    if not items:
        break

    cursor.execute("SELECT MAX(DOC_ID) FROM F1_JSON_DOCS")
    current_max_id = cursor.fetchone()[0] or 0

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    json_text = json.dumps(items)

    cursor.execute("""
        INSERT INTO F1_JSON_DOCS (
            DOC_ID, DOC_TYPE, DATE_LOADED, 
            SEASON, RACE, LAPNUMBER, RACETYPE, F1_DOCUMENT
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        current_max_id + 1,
        doc_type,
        now,
        None, None, None, None,
        json_text
    ))

    conn.commit()
    offset += limit
    print(f"Fetched and stored {len(items)} items. Continuing...")

print("Data fetching and storing completed.")

# Step 7: Create relational view from JSON content
cursor.execute("""
CREATE VIEW IF NOT EXISTS V_F1_OFFICIAL_LAPTIME AS
SELECT
  json_extract(value, '$.season') AS SEASON,
  json_extract(value, '$.race') AS RACE,
  json_extract(value, '$.racetype') AS RACETYPE,
  json_extract(value, '$.datapoint') AS DATAPOINT,
  json_extract(value, '$.time') AS TIME,
  json_extract(value, '$.driver') AS DRIVER,
  json_extract(value, '$.drivernumber') AS DRIVERNUMBER,
  json_extract(value, '$.laptime') AS LAPTIME,
  json_extract(value, '$.lapnumber') AS LAPNUMBER,
  json_extract(value, '$.stint') AS STINT,
  json_extract(value, '$.pitouttime') AS PITOUTTIME,
  json_extract(value, '$.pitintime') AS PITINTIME,
  json_extract(value, '$.sector1time') AS SECTOR1TIME,
  json_extract(value, '$.sector2time') AS SECTOR2TIME,
  json_extract(value, '$.sector3time') AS SECTOR3TIME,
  json_extract(value, '$.sector1sessiontime') AS SECTOR1SESSIONTIME,
  json_extract(value, '$.sector2sessiontime') AS SECTOR2SESSIONTIME,
  json_extract(value, '$.sector3sessiontime') AS SECTOR3SESSIONTIME,
  json_extract(value, '$.speedi1') AS SPEEDI1,
  json_extract(value, '$.speedi2') AS SPEEDI2,
  json_extract(value, '$.speedfl') AS SPEEDFL,
  json_extract(value, '$.speedst') AS SPEEDST,
  json_extract(value, '$.ispersonalbest') AS ISPERSONALBEST,
  json_extract(value, '$.compound') AS COMPOUND,
  json_extract(value, '$.tyrelife') AS TYRELIFE,
  json_extract(value, '$.freshtyre') AS FRESHTYRE,
  json_extract(value, '$.team') AS TEAM,
  json_extract(value, '$.lapstarttime') AS LAPSTARTTIME,
  json_extract(value, '$.lapstartdate') AS LAPSTARTDATE,
  json_extract(value, '$.trackstatus') AS TRACKSTATUS,
  json_extract(value, '$.position') AS POSITION,
  json_extract(value, '$.deleted') AS DELETED,
  json_extract(value, '$.deletedreason') AS DELETEDREASON,
  json_extract(value, '$.fatf1generated') AS FATF1GENERATED,
  json_extract(value, '$.isaccurate') AS ISACCURATE
FROM F1_JSON_DOCS,
     json_each(F1_JSON_DOCS.F1_DOCUMENT)
WHERE DOC_TYPE = 12;
""")
print("View V_F1_OFFICIAL_LAPTIME created successfully.")

# Step 8: Refresh F1_OFFICIAL_TIMEDATA with data from the view
print("Refreshing F1_OFFICIAL_TIMEDATA...")
cursor.execute("DELETE FROM F1_OFFICIAL_TIMEDATA")
cursor.execute("""
INSERT INTO F1_OFFICIAL_TIMEDATA (
    SEASON, RACE, RACETYPE, DATAPOINT, TIME, DRIVER, DRIVERNUMBER, LAPTIME,
    LAPNUMBER, STINT, PITOUTTIME, PITINTIME, SECTOR1TIME, SECTOR2TIME, SECTOR3TIME,
    SECTOR1SESSIONTIME, SECTOR2SESSIONTIME, SECTOR3SESSIONTIME, SPEEDI1, SPEEDI2,
    SPEEDFL, SPEEDST, ISPERSONALBEST, COMPOUND, TYRELIFE, FRESHTYRE, TEAM,
    LAPSTARTTIME, LAPSTARTDATE, TRACKSTATUS, POSITION, DELETED, DELETEDREASON,
    FATF1GENERATED, ISACCURATE
)
SELECT * FROM V_F1_OFFICIAL_LAPTIME
""")
conn.commit()
print("F1_OFFICIAL_TIMEDATA has been refreshed.")

# Load weather data 

cursor.execute("SELECT 1 FROM F1_JSON_DOCTYPE WHERE ID = 13 AND DOC_TYPE = 'F1_OFFICIAL_WEATHER'")
if cursor.fetchone() is None:
    cursor.execute("INSERT INTO F1_JSON_DOCTYPE (ID, DOC_TYPE) VALUES (?, ?)", (13, "F1_OFFICIAL_WEATHER"))
    conn.commit()

cursor.execute("DELETE FROM F1_JSON_DOCS WHERE DOC_TYPE = 13")
conn.commit()
print("Old data in F1_JSON_DOCS with DOC_TYPE = 13 has been deleted.")

base_url = "https://fedora-oracle-linux--amd-lon1-01:8443/ords/f1_rest_access/f1_weather_data/"
limit = 1000
offset = 0
doc_type = 13

while True:
    response = requests.get(base_url, params={'limit': limit, 'offset': offset}, verify=False)
    if response.status_code != 200:
        print(f"Failed to fetch data: {response.status_code}")
        break

    data = response.json()
    items = data.get("items", [])
    if not items:
        break

    cursor.execute("SELECT MAX(DOC_ID) FROM F1_JSON_DOCS")
    current_max_id = cursor.fetchone()[0] or 0

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    json_text = json.dumps(items)

    cursor.execute("""
        INSERT INTO F1_JSON_DOCS (
            DOC_ID, DOC_TYPE, DATE_LOADED, 
            SEASON, RACE, LAPNUMBER, RACETYPE, F1_DOCUMENT
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        current_max_id + 1,
        doc_type,
        now,
        None, None, None, None,
        json_text
    ))

    conn.commit()
    offset += limit
    print(f"Fetched and stored {len(items)} items. Continuing...")

print("Data fetching and storing completed.")

# Step 7: Create relational view from JSON content
cursor.execute("""
CREATE VIEW IF NOT EXISTS V_F1_WEATHERDATA AS
SELECT
    json_extract(entry.value, '$.year') AS year,
    json_extract(entry.value, '$.race') AS race,
    json_extract(entry.value, '$.racetype') AS racetype,
    json_extract(entry.value, '$.datapoint') AS datapoint,
    json_extract(entry.value, '$.time') AS time,
    json_extract(entry.value, '$.airtemp') AS airtemp,
    json_extract(entry.value, '$.humidity') AS humidity,
    json_extract(entry.value, '$.pressure') AS pressure,
    json_extract(entry.value, '$.rainfall') AS rainfall,
    json_extract(entry.value, '$.tracktemp') AS tracktemp,
    json_extract(entry.value, '$.winddirection') AS winddirection,
    json_extract(entry.value, '$.windspeed') AS windspeed
FROM F1_JSON_DOCS AS doc,
     json_each(doc.F1_DOCUMENT) AS entry
WHERE doc.DOC_TYPE = 13;
""")
print("View V_F1_WEATHERDATA created successfully.") 

print("Refreshing F1_OFFICIAL_TIMEDATA...")
cursor.execute("DELETE FROM F1_OFFICIAL_WEATHER")

cursor.execute("""
INSERT INTO F1_OFFICIAL_WEATHER (
YEAR, RACE, RACETYPE, DATAPOINT, 
TIME, AIRTEMP, HUMIDITY, PRESSURE, 
RAINFALL, TRACKTEMP, WINDDIRECTION, 
WINDSPEED
)
SELECT * FROM V_F1_WEATHERDATA
""")

conn.commit()
print("F1_OFFICIAL_WEATHER has been refreshed.")
   
# Close connection
conn.close()
print("All tasks completed successfully.")
