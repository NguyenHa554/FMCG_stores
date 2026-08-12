DROP TABLE IF EXISTS monthly_category_contribution_summary;

CREATE TABLE monthly_category_contribution_summary AS
WITH monthly_total AS (
    SELECT
        SalesMonth,
        SUM(category_revenue) AS monthly_revenue
    FROM monthly_category_revenue_summary
    GROUP BY SalesMonth
)
SELECT
    mcr.SalesMonth,
    mcr.CategoryName,
    mcr.category_revenue,
    mt.monthly_revenue,
    ROUND(mcr.category_revenue / mt.monthly_revenue * 100, 2) AS contribution_pct,
    mcr.category_quantity,
    mcr.total_transactions
FROM monthly_category_revenue_summary mcr
JOIN monthly_total mt
    ON mcr.SalesMonth = mt.SalesMonth;