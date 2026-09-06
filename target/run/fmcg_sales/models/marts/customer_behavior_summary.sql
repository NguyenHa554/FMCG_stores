
    

    create  table
      "fmcg"."main"."customer_behavior_summary__dbt_tmp"
  
    
    as (
      select
    c.CustomerID,
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
    ci.CityName,
    co.CountryName,
    sca.total_transactions,
    sca.total_quantity,
    sca.total_revenue,
    sca.avg_quantity_per_transaction,
    sca.avg_order_value,
    sca.first_purchase_date,
    sca.last_purchase_date
from "fmcg"."main"."sales_customer_agg" sca
join "fmcg"."main"."stg_customers" c
    on sca.CustomerID = c.CustomerID
join "fmcg"."main"."stg_cities" ci
    on c.CityID = ci.CityID
join "fmcg"."main"."stg_countries" co
    on ci.CountryID = co.CountryID
    );
    
  