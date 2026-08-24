DROP TABLE IF EXISTS customer_segment_summary;

CREATE TABLE customer_segment_summary AS
WITH thresholds AS (
    SELECT
        AVG(avg_order_value) AS avg_aov_threshold,
        AVG(total_transactions) AS avg_frequency_threshold
    FROM customer_behavior_summary
)
SELECT
    cbs.*,
    CASE
        WHEN cbs.avg_order_value >= t.avg_aov_threshold
             AND cbs.total_transactions >= t.avg_frequency_threshold
            THEN 'VIP Customers'

        WHEN cbs.avg_order_value >= t.avg_aov_threshold
             AND cbs.total_transactions < t.avg_frequency_threshold
            THEN 'Premium Occasional Customers'

        WHEN cbs.avg_order_value < t.avg_aov_threshold
             AND cbs.total_transactions >= t.avg_frequency_threshold
            THEN 'Loyal Low-Value Customers'

        ELSE 'Regular Customers'
    END AS customer_segment
FROM customer_behavior_summary cbs
CROSS JOIN thresholds t;