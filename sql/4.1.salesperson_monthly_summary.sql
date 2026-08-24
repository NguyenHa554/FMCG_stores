-- Mission 4.1/4.3 salesperson monthly summary.
-- This script aggregates the large sales table by SalesPersonID and SalesMonth
-- first, then joins the small employee dimension after the data has been reduced.

SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'sales'
      AND index_name = 'idx_sales_person_date_product_metrics'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_sales_person_date_product_metrics ON sales(SalesPersonID, SalesDate, ProductID, Quantity, Discount)',
    'SELECT ''idx_sales_person_date_product_metrics already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

DROP TABLE IF EXISTS sales_person_monthly_agg;

CREATE TABLE sales_person_monthly_agg (
    SalesMonth CHAR(7) NOT NULL,
    SalesPersonID INT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (SalesMonth, SalesPersonID),
    INDEX idx_sales_person_monthly_person (SalesPersonID),
    INDEX idx_sales_person_monthly_revenue (total_revenue)
);

INSERT INTO sales_person_monthly_agg (
    SalesMonth,
    SalesPersonID,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction
)
SELECT
    DATE_FORMAT(s.SalesDate, '%Y-%m') AS SalesMonth,
    s.SalesPersonID,
    COUNT(*) AS total_transactions,
    SUM(s.Quantity) AS total_quantity,
    ROUND(SUM(s.Quantity * p.Price * (1 - s.Discount)), 4) AS total_revenue,
    ROUND(
        SUM(s.Quantity * p.Price * (1 - s.Discount)) / NULLIF(COUNT(*), 0),
        4
    ) AS avg_revenue_per_transaction
FROM sales s FORCE INDEX (idx_sales_person_date_product_metrics)
JOIN products p
    ON s.ProductID = p.ProductID
WHERE s.SalesDate IS NOT NULL
GROUP BY
    DATE_FORMAT(s.SalesDate, '%Y-%m'),
    s.SalesPersonID;

DROP TABLE IF EXISTS salesperson_monthly_summary;

CREATE TABLE salesperson_monthly_summary (
    SalesMonth CHAR(7) NOT NULL,
    SalesPersonID INT NOT NULL,
    SalesPersonName VARCHAR(120) NOT NULL,
    Gender VARCHAR(1) NOT NULL,
    HireDate DATETIME NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (SalesMonth, SalesPersonID),
    INDEX idx_salesperson_monthly_person (SalesPersonID),
    INDEX idx_salesperson_monthly_name (SalesPersonName),
    INDEX idx_salesperson_monthly_revenue (total_revenue)
);

INSERT INTO salesperson_monthly_summary (
    SalesMonth,
    SalesPersonID,
    SalesPersonName,
    Gender,
    HireDate,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction
)
SELECT
    spma.SalesMonth,
    e.EmployeeID AS SalesPersonID,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalesPersonName,
    e.Gender,
    e.HireDate,
    spma.total_transactions,
    spma.total_quantity,
    spma.total_revenue,
    spma.avg_revenue_per_transaction
FROM sales_person_monthly_agg spma
JOIN employees e
    ON spma.SalesPersonID = e.EmployeeID;
