with monthly_total as (
    select
        SalesMonth,
        sum(category_revenue) as monthly_revenue
    from {{ ref('monthly_category_revenue_summary') }}
    group by SalesMonth
)

select
    mcr.SalesMonth,
    mcr.CategoryName,
    mcr.category_revenue,
    mt.monthly_revenue,
    round(mcr.category_revenue / mt.monthly_revenue * 100, 2) as contribution_pct,
    mcr.category_quantity,
    mcr.total_transactions
from {{ ref('monthly_category_revenue_summary') }} mcr
join monthly_total mt
    on mcr.SalesMonth = mt.SalesMonth
