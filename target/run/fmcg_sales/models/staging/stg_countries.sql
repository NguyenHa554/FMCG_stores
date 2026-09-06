
  
  create view "fmcg"."main"."stg_countries__dbt_tmp" as (
    select
    CountryID,
    CountryName
from "fmcg"."raw"."countries"
  );
