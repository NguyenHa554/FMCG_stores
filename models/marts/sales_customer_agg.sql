select
    s.CustomerID,
    count(*) as total_transactions,
    sum(s.Quantity) as total_quantity,
    round(sum(s.Quantity * p.Price * (1 - s.Discount)), 4) as total_revenue,
    round(avg(s.Quantity), 4) as avg_quantity_per_transaction,
    round(avg(s.Quantity * p.Price * (1 - s.Discount)), 4) as avg_order_value,
    min(s.SalesDate) as first_purchase_date,
    max(s.SalesDate) as last_purchase_date
from {{ ref('stg_sales') }} s
join {{ ref('stg_products') }} p
    on s.ProductID = p.ProductID
where s.SalesDate is not null
group by s.CustomerID
