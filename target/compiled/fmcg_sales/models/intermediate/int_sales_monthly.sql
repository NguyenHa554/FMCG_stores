

select
    SalesMonth,
    round(sum(Revenue), 4) as total_revenue,
    sum(Quantity) as total_quantity,
    count(*) as transaction_count
from "fmcg"."main"."int_sales_metrics"
where SalesDate is not null
group by SalesMonth