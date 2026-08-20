create table monthly_revenue_change as
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(s.SalesDate, '%Y-%m') AS SalesMonth,
        SUM(s.Quantity * p.Price * (1 - s.Discount)) AS total_revenue
    FROM sales s
    JOIN products p
        ON s.ProductID = p.ProductID
    WHERE s.SalesDate IS NOT NULL
    GROUP BY DATE_FORMAT(s.SalesDate, '%Y-%m')
)
SELECT
    SalesMonth,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY SalesMonth) AS previous_month_revenue,
    total_revenue - LAG(total_revenue) OVER (ORDER BY SalesMonth) AS revenue_change,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY SalesMonth))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY SalesMonth), 0) * 100,
        2
    ) AS growth_rate_pct
FROM monthly_revenue
ORDER BY SalesMonth;
