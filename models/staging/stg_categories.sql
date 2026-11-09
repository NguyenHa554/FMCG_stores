{{ config(materialized='view') }}

select
    CategoryID,
    CategoryName
from {{ source('raw', 'categories') }}
