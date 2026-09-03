select
    ProductID,
    ProductName,
    CategoryID,
    Class,
    Price
from {{ source('raw', 'products') }}
