
  
    

  create  table
    `sales_of_fmcg_stores`.`int_sales_metrics__dbt_tmp`
    
    
      as
    
    (
      

-- Narrow transaction-level fact table for MySQL analytics.
-- This materializes the product join and revenue calculation once so downstream
-- aggregates do not repeatedly scan sales and join products.
select
    s.SalesID,
    s.SalesDate,
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    s.ProductID,
    s.CustomerID,
    s.SalesPersonID,
    s.Quantity,
    s.Discount,
    s.Quantity * p.Price * (1 - s.Discount) as Revenue
from `sales_of_fmcg_stores`.`sales` s
join `sales_of_fmcg_stores`.`products` p
    on s.ProductID = p.ProductID
    )

  