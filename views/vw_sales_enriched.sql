CREATE OR REPLACE VIEW vw_sales_enriched AS
SELECT
    s.SalesID,
    s.TransactionNumber,
    s.SalesDate,
    DATE(s.SalesDate) AS SalesDay,
    DATE_FORMAT(s.SalesDate, '%Y-%m') AS SalesMonth,

    s.SalesPersonID,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalesPersonName,

    s.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,

    c.CityID,
    ci.CityName,
    co.CountryID,
    co.CountryName,

    s.ProductID,
    p.ProductName,
    p.CategoryID,
    ca.CategoryName,
    p.Class,
    p.Price,

    s.Quantity,
    s.Discount,
    s.Quantity * p.Price * (1 - s.Discount) AS Revenue
FROM sales s
JOIN products p
    ON s.ProductID = p.ProductID
JOIN categories ca
    ON p.CategoryID = ca.CategoryID
JOIN customers c
    ON s.CustomerID = c.CustomerID
JOIN cities ci
    ON c.CityID = ci.CityID
JOIN countries co
    ON ci.CountryID = co.CountryID
JOIN employees e
    ON s.SalesPersonID = e.EmployeeID;