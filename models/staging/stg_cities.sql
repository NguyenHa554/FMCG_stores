{{ config(materialized='view') }}

select
    CityID,
    CityName,
    CountryID
from {{ source('raw', 'cities') }}
