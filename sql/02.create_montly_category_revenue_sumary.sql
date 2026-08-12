drop table if exists monthly_category_revenue_summary;
create table monthly_category_revenue_summary as 
select 
	DATE_FORMAT(s.SalesDate, '%Y-%m') AS SalesMonth,
    ca.CategoryName,
    SUM(s.Quantity * p.Price * (1 - s.Discount)) AS category_revenue,
    SUM(s.Quantity) AS category_quantity,
    COUNT(*) AS total_transactions
FROM sales s
JOIN products p
    ON s.ProductID = p.ProductID
JOIN categories ca
    ON p.CategoryID = ca.CategoryID
WHERE s.SalesDate IS NOT NULL
GROUP BY
    DATE_FORMAT(s.SalesDate, '%Y-%m'),
    ca.CategoryName;