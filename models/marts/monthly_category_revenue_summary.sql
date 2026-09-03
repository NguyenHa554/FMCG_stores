select
    SalesMonth,
    CategoryName,
    sum(Revenue) as category_revenue,
    sum(Quantity) as category_quantity,
    count(*) as total_transactions
from {{ ref('int_sales_enriched') }}
where SalesDate is not null
group by
    SalesMonth,
    CategoryName
