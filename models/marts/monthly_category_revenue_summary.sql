select
    ism.SalesMonth,
    ca.CategoryName,
    sum(ism.Revenue) as category_revenue,
    sum(ism.Quantity) as category_quantity,
    count(*) as total_transactions
from {{ ref('int_sales_metrics') }} ism
join {{ ref('stg_products') }} p
    on ism.ProductID = p.ProductID
join {{ ref('stg_categories') }} ca
    on p.CategoryID = ca.CategoryID
where ism.SalesDate is not null
group by
    ism.SalesMonth,
    ca.CategoryName
