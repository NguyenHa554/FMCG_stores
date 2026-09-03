select
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    s.SalesPersonID,
    count(*) as total_transactions,
    sum(s.Quantity) as total_quantity,
    round(sum(s.Quantity * p.Price * (1 - s.Discount)), 4) as total_revenue,
    round(
        sum(s.Quantity * p.Price * (1 - s.Discount)) / nullif(count(*), 0),
        4
    ) as avg_revenue_per_transaction
from {{ source('raw', 'sales') }} s FORCE INDEX (idx_sales_person_date_product_metrics)
join {{ source('raw', 'products') }} p
    on s.ProductID = p.ProductID
where s.SalesDate is not null
group by
    date_format(s.SalesDate, '%Y-%m'),
    s.SalesPersonID
