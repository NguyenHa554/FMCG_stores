"""Verify that a built DuckDB warehouse can be opened and contains key outputs."""

import argparse
from pathlib import Path

import duckdb

RAW_TABLES = (
    "sales",
    "products",
    "categories",
    "customers",
    "cities",
    "countries",
    "employees",
)

PUBLISHED_MODELS = (
    "mart_revenue",
    "mart_product",
    "mart_customer",
    "mart_salesperson",
    "mart_geography",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--db-path", required=True, type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    db_path = args.db_path.resolve()
    if not db_path.is_file() or db_path.stat().st_size == 0:
        raise SystemExit(f"Warehouse does not exist or is empty: {db_path}")

    con = duckdb.connect(str(db_path), read_only=True)
    try:
        for table in RAW_TABLES:
            count = con.execute(f"select count(*) from raw.{table}").fetchone()[0]
            if count == 0:
                raise RuntimeError(f"raw.{table} is empty")

        available = {
            row[0]
            for row in con.execute(
                """
                select table_name
                from information_schema.tables
                where table_schema = 'main'
                  and table_type = 'BASE TABLE'
                """
            ).fetchall()
        }
        missing = sorted(set(PUBLISHED_MODELS) - available)
        if missing:
            raise RuntimeError(f"Missing published models: {', '.join(missing)}")

        for model in PUBLISHED_MODELS:
            count = con.execute(f"select count(*) from main.{model}").fetchone()[0]
            if count == 0:
                raise RuntimeError(f"main.{model} is empty")
    finally:
        con.close()

    print(
        f"Validated {len(RAW_TABLES)} raw tables and "
        f"{len(PUBLISHED_MODELS)} published models in {db_path}"
    )


if __name__ == "__main__":
    main()
