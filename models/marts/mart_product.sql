{{ config(materialized='table') }}

select
    ProductID,
    ProductName,
    CategoryName,
    Class,
    Price,
    total_quantity,
    total_transactions,
    avg_discount,
    discounted_quantity,
    total_revenue,
    revenue_per_unit
from {{ ref('int_product') }}
