
  create view `sales_of_fmcg_stores`.`stg_countries__dbt_tmp`
    
    
  as (
    select
    CountryID,
    CountryName
from `sales_of_fmcg_stores`.`countries`
  );