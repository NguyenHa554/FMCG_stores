{{
    config(
        materialized='table'
    )
}}

-- Narrow transaction-level fact table for analytics.
-- This materializes the product join and revenue calculation once so downstream
-- aggregates do not repeatedly scan sales and join products.
select
    s.SalesID,
    s.SalesDate,
    strftime(s.SalesDate, '%Y-%m') as SalesMonth,
    s.ProductID,
    s.CustomerID,
    s.SalesPersonID,
    s.Quantity,
    s.Discount,
    s.Quantity * p.Price * (1 - s.Discount) as Revenue
from {{ source('raw', 'sales') }} s
join {{ source('raw', 'products') }} p
    on s.ProductID = p.ProductID
