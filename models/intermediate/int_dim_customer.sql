{{ config(materialized='view') }}

select
    c.CustomerID,
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
    c.FirstName,
    c.MiddleInitial,
    c.LastName,
    c.Address,
    c.CityID,
    g.CityName,
    g.CountryID,
    g.CountryName
from {{ ref('stg_customers') }} c
left join {{ ref('int_dim_geography') }} g
    on c.CityID = g.CityID
