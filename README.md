# Sales of FMCG Stores - Business Analytics Project

## Project Overview

This project analyzes a relational FMCG grocery sales dataset and turns it into SQL summary tables and Power BI dashboards for management reporting.

The dataset contains transactional sales records, products, product categories, customers, employees, cities, and countries. The main business goal is to understand revenue performance, product portfolio efficiency, customer behavior, salesperson performance, and geographic market contribution.

## Dataset Structure

Source files are stored in `Dataset/`.

| Table | Purpose |
|---|---|
| `sales` | Main transaction table |
| `products` | Product details, price, category, class |
| `categories` | Product category names |
| `customers` | Customer profile and city |
| `employees` | Salesperson profile |
| `cities` | City and country relationship |
| `countries` | Country information |

Main relationship flow:

```text
sales.ProductID      -> products.ProductID
products.CategoryID  -> categories.CategoryID
sales.CustomerID     -> customers.CustomerID
customers.CityID     -> cities.CityID
cities.CountryID     -> countries.CountryID
sales.SalesPersonID  -> employees.EmployeeID
```

## Important Data Notes

- `sales.TotalPrice` is not reliable because the raw value is `0` for the sales records.
- Actual revenue is calculated as:

```sql
Quantity * Price * (1 - Discount)
```

- Some sales records have missing `SalesDate`, so time-based analysis uses only rows where `SalesDate IS NOT NULL`.
- May 2018 is a partial month because the dataset only includes sales up to `2018-05-09`.
- Geographic analysis is mainly city/region based because all mapped sales are in the United States.
- US region mapping is approximate because the dataset contains `CityName` but does not contain `State`.

## dbt + DuckDB Warehouse

The transformation warehouse is **dbt on DuckDB** (migrated from MySQL). All summary tables are dbt models materialized into a single local file, `fmcg.duckdb`:

```text
Dataset/*.csv  --scripts/load_raw.py-->  fmcg.duckdb (raw schema)
                                              |
                            dbt: staging (views) -> intermediate (views) -> marts (tables, main schema)
```

The full build (25 models + 62 data tests) runs in about 10 seconds; the same pipeline took ~9 minutes for a single model on MySQL.

### Setup

```bash
py -3.12 -m venv .venv-duckdb
.venv-duckdb/Scripts/pip install dbt-duckdb   # dbt-core 1.12 + dbt-duckdb 1.11
```

The dbt profile is `fmcg_sales` / target `duckdb_dev` in `~/.dbt/profiles.yml`, pointing at `fmcg.duckdb` in the project root.

### Run

```bash
# 1. Load raw CSVs into fmcg.duckdb (idempotent, ~4s for 6.8M rows)
.venv-duckdb/Scripts/python scripts/load_raw.py

# 2. Build all models + tests
.venv-duckdb/Scripts/dbt build

# 3. Or run/serve pieces
.venv-duckdb/Scripts/dbt run --select marts
.venv-duckdb/Scripts/dbt test
```

Notes:

- Raw tables live in the `raw` schema (`raw.sales`, `raw.products`, ...); marts land in `main`.
- DuckDB allows one writer at a time: don't run two `dbt build`s concurrently, and avoid refreshing Power BI while building.
- `fmcg.duckdb` / `*.duckdb.wal` are gitignored; rebuild them any time with the two commands above.
- The legacy manual pipeline in `sql/` and the MySQL server are kept for reference/rollback only (see tag `mysql-baseline`).

## SQL Summary Pipeline (legacy, MySQL)

> Superseded by the dbt + DuckDB pipeline above; kept for reference.

The project uses summary tables instead of querying the full sales table directly in Power BI. This improves performance and avoids timeout issues on the 6.7M+ row sales table.

Recommended script order:

```text
sql/01.monthly_revenue.sql
sql/01.revenue_change.sql
sql/02.create_montly_category_revenue_sumary.sql
sql/02.monthly_category_contribution_summary.sql

sql/2.1.Sales_products_agg.sql
sql/2.2.Product_perfomance_summary.sql
sql/2.3.Product class sumary.sql

sql/3.1.customer_behavior_summary.sql
sql/3.2.customer_repeat_summary.sql
sql/3.3.customer_segment_summary.sql

sql/4.1.salesperson_monthly_summary.sql
sql/4.2.salesperson_performance_summary.sql

sql/5.1.geographic_revenue_summary.sql
sql/5.2.geographic_region_summary.sql
```

## Dashboard Pages

Power BI dashboards are stored in `dashboards/`.

| Dashboard | Business Focus |
|---|---|
| `revenue change.pbix` | Revenue trend and category contribution |
| `Product Allocation and Classification.pbix` | Product ranking, product class, and quantity vs revenue |
| `Customer_behavior.pbix` | Customer segmentation, repeat customers, AOV, basket size |
| `Salepersons summary.pbix` | Salesperson revenue, transactions, and monthly trend |
| `Geographic_summary.pbix` | City, region, and market concentration analysis |

Dashboard screenshots are available in `dashboards/screenshots/`.

### Migrating dashboards to DuckDB (later)

The dashboards currently keep refreshing from the legacy MySQL tables. When ready to move them onto `fmcg.duckdb`:

1. Install the DuckDB ODBC driver (Windows x64) from `github.com/duckdb/duckdb-odbc` releases.
2. Create a System DSN (ODBC Data Sources (64-bit)) named e.g. `FMCG DuckDB`, pointing the database at the project's `fmcg.duckdb`.
3. In each PBIX: Power Query -> replace the MySQL source with `Get Data -> ODBC -> FMCG DuckDB`, then re-map tables. Mart table names are identical (`main.monthly_revenue`, `main.customer_behavior_summary`, ...), so remapping is mechanical.
4. Caveat: DuckDB is single-writer. Close/finish dashboard refreshes before running `dbt build`, or export marts to Parquet and point Power BI at the files instead.

## Business Insights

### 1. Revenue Performance Over Time

Revenue is stable across the complete months from January to April 2018, with March being the strongest month. February declines compared with January, then March recovers, while April shows a smaller decrease.

May 2018 should not be interpreted as a true business decline because it only contains partial data up to `2018-05-09`. Trend conclusions should focus mainly on January to April.

Category contribution over time shows which product groups drive monthly revenue. A 100% stacked column chart is the best visual for this mission because it compares each category's share across months.

### 2. Product Allocation and Classification

Product performance is analyzed using product-level revenue, quantity, transaction count, average discount, and revenue per unit.

Top products by revenue identify the main revenue drivers that should be prioritized in inventory planning. Bottom products highlight items that may need promotion, pricing review, or lower stocking priority.

Quantity vs revenue analysis is more useful when combined with `revenue_per_unit`, because many products have similar quantity ranges. This helps separate high-demand low-value products from high-value products.

Product `Class` has a measurable effect on portfolio performance. Revenue, quantity, average revenue per product, and revenue per unit should be compared together rather than relying on total revenue alone.

### 3. Customer Behavior and Segmentation

Customer segmentation is based on two key metrics:

```text
Average Order Value (AOV)
Purchase Frequency
```

The four customer segments are:

| Segment | Meaning |
|---|---|
| VIP Customers | High AOV and high purchase frequency |
| Premium Occasional Customers | High AOV but lower purchase frequency |
| Loyal Low-Value Customers | Lower AOV but high purchase frequency |
| Regular Customers | Lower AOV and lower purchase frequency |

VIP customers are the most valuable CRM target because they contribute a larger share of revenue than their customer count share.

All customers in the dataset are repeat customers, so one-time buyer analysis is limited. Basket size is interpreted as average quantity per transaction, not a true multi-product basket, because `TransactionNumber` behaves like a row-level transaction identifier.

### 4. Salesperson Performance

Salesperson revenue is relatively balanced, so ranking employees only by revenue does not show the full performance picture.

A better evaluation combines:

```text
Total revenue
Total transactions
Average revenue per transaction
Monthly consistency
```

Top performers are the employees with high revenue and high transaction volume. If revenue differences are small, salesperson segmentation should also consider transaction volume and average revenue per transaction to distinguish high-volume operators from high-value sellers.

The monthly trend table contains about 115 rows because it stores one row per salesperson per month:

```text
23 salespeople x 5 sales months = 115 rows
```

### 5. Geographic Revenue Analysis

All mapped sales belong to the United States, so country-level comparison is not meaningful. The analysis therefore focuses on cities and approximate US regions.

The main geographic comparisons are:

```text
Top cities by revenue
Top cities by quantity
Revenue by US region
Revenue per customer by region
Top 3 city revenue concentration
```

The top 3 city revenue concentration ratio measures how much revenue is generated by the three biggest cities:

```text
Top 3 city revenue / Total revenue
```

If this ratio is low, revenue is well distributed across many cities. If it is high, the market is concentrated and depends heavily on a few cities.

## Recommended Presentation Flow

1. Explain the data model and revenue correction.
2. Show overall revenue trend and category contribution.
3. Discuss product winners, weak products, and product class performance.
4. Explain customer segmentation and CRM implications.
5. Evaluate salesperson performance using revenue, transactions, and trend consistency.
6. End with geographic market concentration and regional strategy insights.

## Key Takeaway

The dataset supports a complete management analytics workflow. The strongest business value comes from using corrected revenue, summary tables for performance, and dashboards that connect each metric to a practical decision: inventory planning, CRM targeting, salesperson evaluation, and regional market prioritization.
