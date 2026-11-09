{{ config(materialized='view') }}

select
    CustomerID,
    FirstName,
    MiddleInitial,
    LastName,
    CityID,
    Address
from {{ source('raw', 'customers') }}
