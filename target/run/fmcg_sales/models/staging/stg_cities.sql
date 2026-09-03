
  create view `sales_of_fmcg_stores`.`stg_cities__dbt_tmp`
    
    
  as (
    select
    CityID,
    CityName,
    CountryID
from `sales_of_fmcg_stores`.`cities`
  );