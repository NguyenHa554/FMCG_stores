"""Load source CSV files into the raw schema of a DuckDB database.

Replaces Dataset/upload_*.sql (MySQL LOAD DATA INFILE). Safe to re-run:
every table is CREATE OR REPLACE, so raw always matches the CSVs.

Run: python scripts/load_raw.py [--csv-dir PATH] [--db-path PATH]
"""

import argparse
import os
from pathlib import Path

import duckdb

PROJECT_DIR = Path(__file__).resolve().parent.parent

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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--csv-dir",
        type=Path,
        default=Path(os.environ.get("FMCG_CSV_DIR", PROJECT_DIR / "Dataset")),
        help="directory containing the seven source CSV files",
    )
    parser.add_argument(
        "--db-path",
        type=Path,
        default=Path(os.environ.get("FMCG_DB_PATH", PROJECT_DIR / "fmcg.duckdb")),
        help="DuckDB database to create or update",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    csv_dir = args.csv_dir.resolve()
    db_path = args.db_path.resolve()

    missing = [csv_dir / f"{table}.csv" for table in TABLES]
    missing = [path for path in missing if not path.is_file()]
    if missing:
        names = ", ".join(path.name for path in missing)
        raise SystemExit(f"Missing source CSV files in {csv_dir}: {names}")

    db_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db_path))
    try:
        con.execute("CREATE SCHEMA IF NOT EXISTS raw")
        for table, columns in TABLES.items():
            cols_sql = ", ".join(
                f"'{name}': '{dtype}'" for name, dtype in columns.items()
            )
            csv_path = str(csv_dir / f"{table}.csv")
            con.execute(
                f"""
                CREATE OR REPLACE TABLE raw.{table} AS
                SELECT * FROM read_csv(
                    ?,
                    header = true,
                    columns = {{{cols_sql}}}
                )
                """,
                [csv_path],
            )
            count = con.execute(f"SELECT count(*) FROM raw.{table}").fetchone()[0]
            if count == 0:
                raise RuntimeError(f"raw.{table} is empty; refusing to continue")
            print(f"raw.{table}: {count:,} rows")
    finally:
        con.close()

    print(f"Loaded raw data into {db_path}")


if __name__ == "__main__":
    main()
