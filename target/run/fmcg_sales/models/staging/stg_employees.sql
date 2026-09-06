
  
  create view "fmcg"."main"."stg_employees__dbt_tmp" as (
    select
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    HireDate
from "fmcg"."raw"."employees"
  );
