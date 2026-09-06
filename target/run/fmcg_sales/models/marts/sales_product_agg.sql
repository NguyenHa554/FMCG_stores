
    

    create  table
      "fmcg"."main"."sales_product_agg__dbt_tmp"
  
    
    as (
      select
    ProductID,
    sum(Quantity) as total_quantity,
    count(*) as total_transactions,
    round(avg(Discount), 6) as avg_discount,
    round(sum(Quantity * (1 - Discount)), 6) as discounted_quantity
from "fmcg"."main"."int_sales_metrics"
group by ProductID
    );
    
  