SELECT
    DATE_FORMAT(s.SalesDate,'%Y-%m') AS SalesMonth,
    SUM(s.Quantity * p.Price * (1-s.Discount)) AS Revenue,
    SUM(s.Quantity) AS Quantity,
    COUNT(*) AS Transactions
FROM sales s
JOIN products p
    ON s.ProductID = p.ProductID
GROUP BY DATE_FORMAT(s.SalesDate,'%Y-%m')
ORDER BY SalesMonth;