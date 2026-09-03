
  create view `sales_of_fmcg_stores`.`stg_categories__dbt_tmp`
    
    
  as (
    select
    CategoryID,
    CategoryName
from `sales_of_fmcg_stores`.`categories`
  );