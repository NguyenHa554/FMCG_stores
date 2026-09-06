
  
  create view "fmcg"."main"."stg_products__dbt_tmp" as (
    select
    ProductID,
    ProductName,
    CategoryID,
    Class,
    Price
from "fmcg"."raw"."products"
  );
