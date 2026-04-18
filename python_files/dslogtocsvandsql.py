import subprocess
import time
import pyautogui
import pydirectinput
import sys
import os
import pandas as pd
from sqlalchemy import create_engine

print("Total arguments:", len(sys.argv))
print("Script name:", sys.argv[0])
print("Arguments:", sys.argv[1:])

# Configuration
AS_PATH = r"ADVANTAGE_SCOPE_PATH_HERE" #change to your install of Advantage Scope
LOG_PATH = sys.argv[1]
#print(LOG_PATH)
def export_dslog(LOG_PATH):
    # 1. Configuration
    
    
    # Validation
    if not os.path.exists(AS_PATH):
        print(f"Error: AdvantageScope not found at {AS_PATH}")
        return
    if not os.path.exists(LOG_PATH):
        print(f"Error: Log file not found at {LOG_PATH}")
        return

    print(f"Opening: {os.path.basename(LOG_PATH)}")




# 1. Launch AdvantageScope with the file
subprocess.Popen([AS_PATH, LOG_PATH])

# 2. Wait for the UI to load and process the log
time.sleep(2.5) 
print("open")

# 3. Export shortcut (Ctrl+Shift+E is common for DS Log export in AS)
pyautogui.hotkey('ctrl', 'e')
print("export")
time.sleep(1.5)
print("export2")


# 4. Confirm the Save dialog
pydirectinput.press('enter')
#pyautogui.press('enter')
#pyautogui.keyUp('enter')
print("enter")
print("Export initiated.")

time.sleep(2)
pydirectinput.press('enter')
print("export finished")
subprocess.call("TASKKILL " + AS_PATH, shell=True)

for i in range(10):
    time.sleep(1)
    print(i)

CSV_PATH = os.path.splitext(LOG_PATH)[0]+".csv"
print(CSV_PATH)
# 1. Load your CSV
df = pd.read_csv(CSV_PATH)
print(df)

# 2. Create a connection to the database
# For SQLite: 'sqlite:///destination_db.db'
# For Postgres: 'postgresql://user:pass@localhost:5432/db_name'
base_path = os.path.splitext(LOG_PATH)[0]
engine = create_engine(f"sqlite:///{base_path}.db")
# 3. Convert CSV to SQL
# 'if_exists' can be 'fail', 'replace', or 'append'
df.to_sql('table_name', con=engine, index=False, if_exists='replace')

print("Conversion complete!")
