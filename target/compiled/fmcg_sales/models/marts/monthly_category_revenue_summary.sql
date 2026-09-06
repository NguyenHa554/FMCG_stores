select
    ism.SalesMonth,
    ca.CategoryName,
    sum(ism.Revenue) as category_revenue,
    sum(ism.Quantity) as category_quantity,
    count(*) as total_transactions
from `sales_of_fmcg_stores`.`int_sales_metrics` ism
join `sales_of_fmcg_stores`.`stg_products` p
    on ism.ProductID = p.ProductID
join `sales_of_fmcg_stores`.`stg_categories` ca
    on p.CategoryID = ca.CategoryID
where ism.SalesDate is not null
group by
    ism.SalesMonth,
    ca.CategoryName