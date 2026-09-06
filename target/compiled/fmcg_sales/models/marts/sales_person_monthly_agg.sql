select
    SalesMonth,
    SalesPersonID,
    count(*) as total_transactions,
    sum(Quantity) as total_quantity,
    round(sum(Revenue), 4) as total_revenue,
    round(sum(Revenue) / nullif(count(*), 0), 4) as avg_revenue_per_transaction
from "fmcg"."main"."int_sales_metrics"
where SalesDate is not null
group by
    SalesMonth,
    SalesPersonID