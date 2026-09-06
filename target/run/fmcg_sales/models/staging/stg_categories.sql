
  
  create view "fmcg"."main"."stg_categories__dbt_tmp" as (
    select
    CategoryID,
    CategoryName
from "fmcg"."raw"."categories"
  );
