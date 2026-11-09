{{ config(materialized='view') }}

select
    ci.CityID,
    ci.CityName,
    ci.CountryID,
    co.CountryName
from {{ ref('stg_cities') }} ci
left join {{ ref('stg_countries') }} co
    on ci.CountryID = co.CountryID
