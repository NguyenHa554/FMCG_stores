select
    CountryID,
    CountryName
from {{ source('raw', 'countries') }}
