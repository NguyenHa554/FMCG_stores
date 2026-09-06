
  
  create view "fmcg"."main"."stg_cities__dbt_tmp" as (
    select
    CityID,
    CityName,
    CountryID
from "fmcg"."raw"."cities"
  );
