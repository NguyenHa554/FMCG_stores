{{ config(materialized='view') }}

select
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    HireDate
from {{ source('raw', 'employees') }}
