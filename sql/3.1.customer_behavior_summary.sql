
SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'sales'
      AND index_name = 'idx_sales_customer_product_metrics'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_sales_customer_product_metrics ON sales(CustomerID, ProductID, Quantity, Discount, SalesDate)',
    'SELECT ''idx_sales_customer_product_metrics already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'customers'
      AND index_name = 'idx_customers_city'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_customers_city ON customers(CityID)',
    'SELECT ''idx_customers_city already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'cities'
      AND index_name = 'idx_cities_country'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_cities_country ON cities(CountryID)',
    'SELECT ''idx_cities_country already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

DROP TABLE IF EXISTS sales_customer_agg;

CREATE TABLE sales_customer_agg (
    CustomerID INT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    avg_order_value DECIMAL(18,4) NOT NULL,
    first_purchase_date DATETIME NULL,
    last_purchase_date DATETIME NULL,
    PRIMARY KEY (CustomerID),
    INDEX idx_sales_customer_agg_revenue (total_revenue),
    INDEX idx_sales_customer_agg_transactions (total_transactions)
);

INSERT INTO sales_customer_agg (
    CustomerID,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_quantity_per_transaction,
    avg_order_value,
    first_purchase_date,
    last_purchase_date
)
SELECT
    s.CustomerID,
    COUNT(*) AS total_transactions,
    SUM(s.Quantity) AS total_quantity,
    ROUND(SUM(s.Quantity * p.Price * (1 - s.Discount)), 4) AS total_revenue,
    ROUND(AVG(s.Quantity), 4) AS avg_quantity_per_transaction,
    ROUND(AVG(s.Quantity * p.Price * (1 - s.Discount)), 4) AS avg_order_value,
    MIN(s.SalesDate) AS first_purchase_date,
    MAX(s.SalesDate) AS last_purchase_date
FROM sales s FORCE INDEX (idx_sales_customer_product_metrics)
JOIN products p
    ON s.ProductID = p.ProductID
WHERE s.SalesDate IS NOT NULL
GROUP BY s.CustomerID;

DROP TABLE IF EXISTS customer_behavior_summary;

CREATE TABLE customer_behavior_summary (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(120) NOT NULL,
    CityName VARCHAR(45) NOT NULL,
    CountryName VARCHAR(45) NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    avg_order_value DECIMAL(18,4) NOT NULL,
    first_purchase_date DATETIME NULL,
    last_purchase_date DATETIME NULL,
    PRIMARY KEY (CustomerID),
    INDEX idx_customer_behavior_revenue (total_revenue),
    INDEX idx_customer_behavior_transactions (total_transactions),
    INDEX idx_customer_behavior_city (CityName),
    INDEX idx_customer_behavior_country (CountryName)
);

INSERT INTO customer_behavior_summary (
    CustomerID,
    CustomerName,
    CityName,
    CountryName,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_quantity_per_transaction,
    avg_order_value,
    first_purchase_date,
    last_purchase_date
)
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    ci.CityName,
    co.CountryName,
    sca.total_transactions,
    sca.total_quantity,
    sca.total_revenue,
    sca.avg_quantity_per_transaction,
    sca.avg_order_value,
    sca.first_purchase_date,
    sca.last_purchase_date
FROM sales_customer_agg sca
JOIN customers c
    ON sca.CustomerID = c.CustomerID
JOIN cities ci
    ON c.CityID = ci.CityID
JOIN countries co
    ON ci.CountryID = co.CountryID;
