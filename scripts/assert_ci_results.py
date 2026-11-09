"""Assert deterministic Power BI mart results produced from ci/fixtures."""

import argparse
from pathlib import Path

import duckdb


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


def assert_rows(
    con: duckdb.DuckDBPyConnection,
    query: str,
    expected: list[tuple],
    label: str,
) -> None:
    actual = con.execute(query).fetchall()
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")


def assert_five_mart_files() -> None:
    mart_dir = Path(__file__).resolve().parents[1] / "models" / "marts"
    actual = sorted(path.stem for path in mart_dir.rglob("*.sql"))
    expected = sorted(PUBLISHED_MODELS)
    if actual != expected:
        raise AssertionError(
            f"mart SQL files: expected {expected!r}, got {actual!r}"
        )


def main() -> None:
    args = parse_args()
    assert_five_mart_files()

    con = duckdb.connect(str(args.db_path.resolve()), read_only=True)
    try:
        assert_rows(con, "select count(*) from raw.sales", [(6,)], "raw sales count")
        assert_rows(
            con,
            "select count(*) from main.int_sales_metrics where SalesDate is null",
            [(1,)],
            "null sales date coverage",
        )
        assert_rows(
            con,
            "select round(sum(Revenue), 2) from main.int_sales_metrics",
            [(73.0,)],
            "corrected total revenue",
        )
        assert_rows(
            con,
            """
            select SalesMonth, sum(category_revenue), max(monthly_revenue)
            from main.mart_revenue
            group by SalesMonth
            order by SalesMonth
            """,
            [
                ("2018-01", 33.0, 33.0),
                ("2018-02", 25.0, 25.0),
                ("2018-03", 10.0, 10.0),
            ],
            "monthly revenue",
        )
        assert_rows(
            con,
            """
            select SalesMonth, growth_rate_pct, is_partial_month
            from main.mart_revenue
            qualify row_number() over (
                partition by SalesMonth order by CategoryName
            ) = 1
            order by SalesMonth
            """,
            [
                ("2018-01", None, False),
                ("2018-02", -24.24, False),
                ("2018-03", -60.0, True),
            ],
            "monthly growth and completeness",
        )
        assert_rows(
            con,
            """
            select customer_type, count(*), sum(total_revenue)
            from main.mart_customer
            group by customer_type
            order by customer_type
            """,
            [
                ("One-time Buyers", 2, 25.0),
                ("Repeat Customers", 1, 43.0),
            ],
            "customer repeat classification",
        )
        assert_rows(
            con,
            """
            select ProductName, total_quantity, total_revenue
            from main.mart_product
            order by ProductName
            """,
            [
                ("Chips", 9, 35.0),
                ("Coffee", 4, 38.0),
            ],
            "product performance",
        )
        assert_rows(
            con,
            """
            select SalesPersonName, sum(total_transactions),
                   sum(total_revenue),
                   round(sum(total_revenue) / sum(total_transactions), 4)
            from main.mart_salesperson
            group by SalesPersonName
            order by SalesPersonName
            """,
            [
                ("Emma Stone", 3, 38.0, 12.6667),
                ("Liam Jones", 2, 30.0, 15.0),
            ],
            "salesperson average revenue per transaction",
        )
        assert_rows(
            con,
            """
            select USRegion, sum(total_revenue)
            from main.mart_geography
            group by USRegion
            order by USRegion
            """,
            [
                ("Northeast", 43.0),
                ("Other / Unknown", 15.0),
                ("West", 10.0),
            ],
            "geographic region mapping",
        )
        assert_rows(
            con,
            """
            select round(sum(total_revenue), 2)
            from (
                select total_revenue
                from main.mart_geography
                order by total_revenue desc
                limit 3
            )
            """,
            [(68.0,)],
            "top three city revenue",
        )
    finally:
        con.close()

    print("CI fixture assertions passed for five Power BI marts")


if __name__ == "__main__":
    main()
