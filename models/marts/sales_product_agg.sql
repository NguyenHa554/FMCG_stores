select
    ProductID,
    sum(Quantity) as total_quantity,
    count(*) as total_transactions,
    round(avg(Discount), 6) as avg_discount,
    round(sum(Quantity * (1 - Discount)), 6) as discounted_quantity
from {{ ref('stg_sales') }}
group by ProductID
