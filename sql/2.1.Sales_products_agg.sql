
SET @index_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'sales'
      AND index_name = 'idx_sales_product_qty_discount'
);

SET @create_index_sql := IF(
    @index_exists = 0,
    'CREATE INDEX idx_sales_product_qty_discount ON sales(ProductID, Quantity, Discount)',
    'SELECT ''idx_sales_product_qty_discount already exists'' AS info'
);

PREPARE create_index_stmt FROM @create_index_sql;
EXECUTE create_index_stmt;
DEALLOCATE PREPARE create_index_stmt;

DROP TABLE IF EXISTS sales_product_agg;

CREATE TABLE sales_product_agg (
    ProductID INT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    avg_discount DECIMAL(12,6) NOT NULL,
    discounted_quantity DECIMAL(24,6) NOT NULL,
    PRIMARY KEY (ProductID)
);

INSERT INTO sales_product_agg (
    ProductID,
    total_quantity,
    total_transactions,
    avg_discount,
    discounted_quantity
)
SELECT
    s.ProductID,
    SUM(s.Quantity) AS total_quantity,
    COUNT(*) AS total_transactions,
    ROUND(AVG(s.Discount), 6) AS avg_discount,
    ROUND(SUM(s.Quantity * (1 - s.Discount)), 6) AS discounted_quantity
FROM sales s FORCE INDEX (idx_sales_product_qty_discount)
GROUP BY s.ProductID;
