select
    SalesMonth,
    total_revenue,
    lag(total_revenue) over (order by SalesMonth) as previous_month_revenue,
    total_revenue - lag(total_revenue) over (order by SalesMonth) as revenue_change,
    round(
        (total_revenue - lag(total_revenue) over (order by SalesMonth))
        / nullif(lag(total_revenue) over (order by SalesMonth), 0) * 100,
        2
    ) as growth_rate_pct
from "fmcg"."main"."int_sales_monthly"