with product_sales as (
    select
        ProductID,
        sum(Quantity) as total_quantity,
        count(*) as total_transactions,
        round(avg(Discount), 6) as avg_discount,
        round(sum(Quantity * (1 - Discount)), 6) as discounted_quantity
    from {{ ref('int_sales_metrics') }}
    group by ProductID
)

select
    p.ProductID,
    p.ProductName,
    p.CategoryName,
    p.Class,
    p.Price,
    ps.total_quantity,
    ps.total_transactions,
    ps.avg_discount,
    ps.discounted_quantity,
    round(ps.discounted_quantity * p.Price, 4) as total_revenue,
    round(
        ps.discounted_quantity * p.Price / nullif(ps.total_quantity, 0),
        6
    ) as revenue_per_unit
from product_sales ps
join {{ ref('int_dim_product') }} p
    on ps.ProductID = p.ProductID
