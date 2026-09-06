
    

    create  table
      "fmcg"."main"."monthly_revenue__dbt_tmp"
  
    
    as (
      select
    SalesMonth,
    total_revenue as Revenue,
    total_quantity as Quantity,
    transaction_count as Transactions
from "fmcg"."main"."int_sales_monthly"
    );
    
  