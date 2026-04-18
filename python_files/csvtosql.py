import pandas
import os
import sys
from sqlalchemy import create_engine

print("Total arguments:", len(sys.argv))
print("Script name:", sys.argv[0])
print("Arguments:", sys.argv[1:])

LOG_PATH = sys.argv[1]

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