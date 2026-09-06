
    

    create  table
      "fmcg"."main"."monthly_category_revenue_summary__dbt_tmp"
  
    
    as (
      select
    ism.SalesMonth,
    ca.CategoryName,
    sum(ism.Revenue) as category_revenue,
    sum(ism.Quantity) as category_quantity,
    count(*) as total_transactions
from "fmcg"."main"."int_sales_metrics" ism
join "fmcg"."main"."stg_products" p
    on ism.ProductID = p.ProductID
join "fmcg"."main"."stg_categories" ca
    on p.CategoryID = ca.CategoryID
where ism.SalesDate is not null
group by
    ism.SalesMonth,
    ca.CategoryName
    );
    
  