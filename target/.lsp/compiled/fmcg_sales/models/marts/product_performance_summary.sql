select
    p.ProductID,
    p.ProductName,
    ca.CategoryName,
    p.Class,
    p.Price,
    spa.total_quantity,
    spa.total_transactions,
    spa.avg_discount,
    spa.discounted_quantity,
    round(spa.discounted_quantity * p.Price, 4) as total_revenue,
    round(
        spa.discounted_quantity * p.Price / nullif(spa.total_quantity, 0),
        6
    ) as revenue_per_unit
from "fmcg"."main"."sales_product_agg" spa
join "fmcg"."main"."stg_products" p
    on spa.ProductID = p.ProductID
join "fmcg"."main"."stg_categories" ca
    on p.CategoryID = ca.CategoryID