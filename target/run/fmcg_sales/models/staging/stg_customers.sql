
  create view `sales_of_fmcg_stores`.`stg_customers__dbt_tmp`
    
    
  as (
    select
    CustomerID,
    FirstName,
    MiddleInitial,
    LastName,
    CityID,
    Address
from `sales_of_fmcg_stores`.`customers`
  );