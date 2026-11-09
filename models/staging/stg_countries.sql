{{ config(materialized='view') }}

select
    CountryID,
    CountryName
from {{ source('raw', 'countries') }}
