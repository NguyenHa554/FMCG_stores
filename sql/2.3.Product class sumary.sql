DROP TABLE IF EXISTS product_class_summary;

CREATE TABLE product_class_summary AS
SELECT
    Class,
    COUNT(*) AS product_count,
    SUM(total_quantity) AS total_quantity,
    SUM(total_transactions) AS total_transactions,
    SUM(total_revenue) AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(COUNT(*), 0), 4) AS avg_revenue_per_product,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_quantity), 0), 6) AS revenue_per_unit
FROM product_performance_summary
GROUP BY Class;