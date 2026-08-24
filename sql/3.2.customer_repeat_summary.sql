DROP TABLE IF EXISTS customer_repeat_summary;

CREATE TABLE customer_repeat_summary AS
SELECT
    CASE
        WHEN total_transactions > 1 THEN 'Repeat Customers'
        ELSE 'One-time Buyers'
    END AS customer_type,
    COUNT(*) AS customer_count,
    SUM(total_revenue) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM customer_behavior_summary
GROUP BY customer_type;
