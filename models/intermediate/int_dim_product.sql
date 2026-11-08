select
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    c.CategoryName,
    p.Class,
    p.Price
from {{ ref('stg_products') }} p
left join {{ ref('stg_categories') }} c
    on p.CategoryID = c.CategoryID
