"""One-time loader: Dataset/*.csv -> raw schema in fmcg.duckdb.

Replaces Dataset/upload_*.sql (MySQL LOAD DATA INFILE). Safe to re-run:
every table is CREATE OR REPLACE, so raw always matches the CSVs.

Run: .venv-duckdb/Scripts/python scripts/load_raw.py
"""

from pathlib import Path

import duckdb

PROJECT_DIR = Path(__file__).resolve().parent.parent
DB_PATH = PROJECT_DIR / "fmcg.duckdb"
CSV_DIR = PROJECT_DIR / "Dataset"

# column name -> DuckDB type, in CSV column order
TABLES = {
    "sales": {
        "SalesID": "BIGINT",
        "SalesPersonID": "INTEGER",
        "CustomerID": "BIGINT",
        "ProductID": "INTEGER",
        "Quantity": "INTEGER",
        "Discount": "DOUBLE",
        "TotalPrice": "DOUBLE",
        "SalesDate": "TIMESTAMP",
        "TransactionNumber": "VARCHAR",
    },
    "products": {
        "ProductID": "INTEGER",
        "ProductName": "VARCHAR",
        "Price": "DOUBLE",
        "CategoryID": "INTEGER",
        "Class": "VARCHAR",
        "ModifyDate": "TIMESTAMP",
        "Resistant": "VARCHAR",
        "IsAllergic": "VARCHAR",
        "VitalityDays": "INTEGER",
    },
    "categories": {"CategoryID": "INTEGER", "CategoryName": "VARCHAR"},
    "customers": {
        "CustomerID": "BIGINT",
        "FirstName": "VARCHAR",
        "MiddleInitial": "VARCHAR",
        "LastName": "VARCHAR",
        "CityID": "INTEGER",
        "Address": "VARCHAR",
    },
    "cities": {
        "CityID": "INTEGER",
        "CityName": "VARCHAR",
        "Zipcode": "VARCHAR",
        "CountryID": "INTEGER",
    },
    "countries": {
        "CountryID": "INTEGER",
        "CountryName": "VARCHAR",
        "CountryCode": "VARCHAR",
    },
    "employees": {
        "EmployeeID": "INTEGER",
        "FirstName": "VARCHAR",
        "MiddleInitial": "VARCHAR",
        "LastName": "VARCHAR",
        "BirthDate": "TIMESTAMP",
        "Gender": "VARCHAR",
        "CityID": "INTEGER",
        "HireDate": "TIMESTAMP",
    },
}


def main() -> None:
    con = duckdb.connect(str(DB_PATH))
    con.execute("CREATE SCHEMA IF NOT EXISTS raw")
    for table, columns in TABLES.items():
        cols_sql = ", ".join(f"'{name}': '{dtype}'" for name, dtype in columns.items())
        csv_path = (CSV_DIR / f"{table}.csv").as_posix()
        con.execute(
            f"""
            CREATE OR REPLACE TABLE raw.{table} AS
            SELECT * FROM read_csv(
                '{csv_path}',
                header = true,
                columns = {{{cols_sql}}}
            )
            """
        )
        count = con.execute(f"SELECT count(*) FROM raw.{table}").fetchone()[0]
        print(f"raw.{table}: {count:,} rows")
    con.close()


if __name__ == "__main__":
    main()
