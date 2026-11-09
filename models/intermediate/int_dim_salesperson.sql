{{ config(materialized='view') }}

select
    EmployeeID as SalesPersonID,
    concat(FirstName, ' ', LastName) as SalesPersonName,
    FirstName,
    LastName,
    Gender,
    HireDate
from {{ ref('stg_employees') }}
