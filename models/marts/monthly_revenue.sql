select
    SalesMonth,
    sum(Revenue) as Revenue,
    sum(Quantity) as Quantity,
    count(*) as Transactions
from {{ ref('int_sales_enriched') }}
where SalesDate is not null
group by SalesMonth
