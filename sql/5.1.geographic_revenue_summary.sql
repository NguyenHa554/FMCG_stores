-- Mission 5.1 geographic revenue summary.
-- This script uses customer_behavior_summary as the prepared customer-level
-- aggregate, so it does not scan the full sales table again.

SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'customer_behavior_summary'
      AND index_name = 'idx_customer_behavior_city_country'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_customer_behavior_city_country ON customer_behavior_summary(CityName, CountryName)',
    'SELECT ''idx_customer_behavior_city_country already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

DROP TABLE IF EXISTS geographic_city_agg;

CREATE TABLE geographic_city_agg (
    CityName VARCHAR(45) NOT NULL,
    CountryName VARCHAR(45) NOT NULL,
    total_customers BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    revenue_per_customer DECIMAL(18,4) NOT NULL,
    transactions_per_customer DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (CityName, CountryName),
    INDEX idx_geographic_city_agg_revenue (total_revenue),
    INDEX idx_geographic_city_agg_quantity (total_quantity),
    INDEX idx_geographic_city_agg_customers (total_customers)
);

INSERT INTO geographic_city_agg (
    CityName,
    CountryName,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
)
SELECT
    CityName,
    CountryName,
    COUNT(*) AS total_customers,
    SUM(total_transactions) AS total_transactions,
    SUM(total_quantity) AS total_quantity,
    ROUND(SUM(total_revenue), 4) AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_transactions), 0), 4) AS avg_revenue_per_transaction,
    ROUND(SUM(total_quantity) / NULLIF(SUM(total_transactions), 0), 4) AS avg_quantity_per_transaction,
    ROUND(SUM(total_revenue) / NULLIF(COUNT(*), 0), 4) AS revenue_per_customer,
    ROUND(SUM(total_transactions) / NULLIF(COUNT(*), 0), 4) AS transactions_per_customer
FROM customer_behavior_summary FORCE INDEX (idx_customer_behavior_city_country)
GROUP BY
    CityName,
    CountryName;

DROP TABLE IF EXISTS geographic_revenue_summary;

CREATE TABLE geographic_revenue_summary (
    CityName VARCHAR(45) NOT NULL,
    CountryName VARCHAR(45) NOT NULL,
    total_customers BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    revenue_per_customer DECIMAL(18,4) NOT NULL,
    transactions_per_customer DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (CityName, CountryName),
    INDEX idx_geographic_revenue (total_revenue),
    INDEX idx_geographic_quantity (total_quantity),
    INDEX idx_geographic_customers (total_customers),
    INDEX idx_geographic_country (CountryName)
);

INSERT INTO geographic_revenue_summary (
    CityName,
    CountryName,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
)
SELECT
    CityName,
    CountryName,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
FROM geographic_city_agg;
