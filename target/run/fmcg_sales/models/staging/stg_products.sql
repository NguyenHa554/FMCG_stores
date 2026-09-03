
  create view `sales_of_fmcg_stores`.`stg_products__dbt_tmp`
    
    
  as (
    select
    ProductID,
    ProductName,
    CategoryID,
    Class,
    Price
from `sales_of_fmcg_stores`.`products`
  );