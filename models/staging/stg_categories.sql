select
    CategoryID,
    CategoryName
from {{ source('raw', 'categories') }}
