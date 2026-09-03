select
    s.SalesID,
    s.TransactionNumber,
    s.SalesDate,
    date(s.SalesDate) as SalesDay,
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    s.SalesPersonID,
    concat(e.FirstName, ' ', e.LastName) as SalesPersonName,
    s.CustomerID,
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
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
    s.Quantity * p.Price * (1 - s.Discount) as Revenue
from `sales_of_fmcg_stores`.`stg_sales` s
join `sales_of_fmcg_stores`.`stg_products` p
    on s.ProductID = p.ProductID
join `sales_of_fmcg_stores`.`stg_categories` ca
    on p.CategoryID = ca.CategoryID
join `sales_of_fmcg_stores`.`stg_customers` c
    on s.CustomerID = c.CustomerID
join `sales_of_fmcg_stores`.`stg_cities` ci
    on c.CityID = ci.CityID
join `sales_of_fmcg_stores`.`stg_countries` co
    on ci.CountryID = co.CountryID
join `sales_of_fmcg_stores`.`stg_employees` e
    on s.SalesPersonID = e.EmployeeID