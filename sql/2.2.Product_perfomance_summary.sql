-- Mission 2.2 product performance summary.
-- Run sql/2.1.Sales_products_agg.sql first.
-- This query is fast because it joins the small product-level aggregate table
-- instead of scanning the full sales table again.

SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'products'
      AND index_name = 'idx_products_category'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_products_category ON products(CategoryID)',
    'SELECT ''idx_products_category already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

DROP TABLE IF EXISTS product_performance_summary;

CREATE TABLE product_performance_summary (
    ProductID INT NOT NULL,
    ProductName VARCHAR(255) NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    Class VARCHAR(45) NOT NULL,
    Price DECIMAL(18,4) NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    avg_discount DECIMAL(12,6) NOT NULL,
    discounted_quantity DECIMAL(24,6) NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    revenue_per_unit DECIMAL(18,6) NOT NULL,
    PRIMARY KEY (ProductID),
    INDEX idx_product_perf_revenue (total_revenue),
    INDEX idx_product_perf_quantity (total_quantity),
    INDEX idx_product_perf_category (CategoryName),
    INDEX idx_product_perf_class (Class)
);

INSERT INTO product_performance_summary (
    ProductID,
    ProductName,
    CategoryName,
    Class,
    Price,
    total_quantity,
    total_transactions,
    avg_discount,
    discounted_quantity,
    total_revenue,
    revenue_per_unit
)
SELECT
    p.ProductID,
    p.ProductName,
    ca.CategoryName,
    p.Class,
    p.Price,
    spa.total_quantity,
    spa.total_transactions,
    spa.avg_discount,
    spa.discounted_quantity,
    ROUND(spa.discounted_quantity * p.Price, 4) AS total_revenue,
    ROUND(
        spa.discounted_quantity * p.Price / NULLIF(spa.total_quantity, 0),
        6
    ) AS revenue_per_unit
FROM sales_product_agg spa
JOIN products p
    ON spa.ProductID = p.ProductID
JOIN categories ca
    ON p.CategoryID = ca.CategoryID;
