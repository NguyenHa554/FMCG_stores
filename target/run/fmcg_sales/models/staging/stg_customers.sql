
  
  create view "fmcg"."main"."stg_customers__dbt_tmp" as (
    select
    CustomerID,
    FirstName,
    MiddleInitial,
    LastName,
    CityID,
    Address
from "fmcg"."raw"."customers"
  );
