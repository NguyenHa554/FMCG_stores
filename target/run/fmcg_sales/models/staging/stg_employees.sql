
  create view `sales_of_fmcg_stores`.`stg_employees__dbt_tmp`
    
    
  as (
    select
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    HireDate
from `sales_of_fmcg_stores`.`employees`
  );