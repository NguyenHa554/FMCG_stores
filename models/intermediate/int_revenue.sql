{{ config(materialized='view') }}

with category_month as (
    select
        s.SalesMonth,
        p.CategoryName,
        round(sum(s.Revenue), 4) as category_revenue,
        sum(s.Quantity) as category_quantity,
        count(*) as category_transactions
    from {{ ref('int_sales_metrics') }} s
    join {{ ref('int_dim_product') }} p
        on s.ProductID = p.ProductID
    where s.SalesDate is not null
    group by
        s.SalesMonth,
        p.CategoryName
),

monthly_totals as (
    select
        SalesMonth,
        round(sum(Revenue), 4) as monthly_revenue,
        sum(Quantity) as monthly_quantity,
        count(*) as monthly_transactions,
        max(SalesDate) as data_through_date
    from {{ ref('int_sales_metrics') }}
    where SalesDate is not null
    group by SalesMonth
),

monthly_change as (
    select
        *,
        lag(monthly_revenue) over (order by SalesMonth) as previous_month_revenue
    from monthly_totals
),

latest_sale as (
    select max(SalesDate) as latest_sales_date
    from {{ ref('int_sales_metrics') }}
)

select
    concat(cm.SalesMonth, '|', cm.CategoryName) as mart_revenue_id,
    cm.SalesMonth,
    cm.CategoryName,
    cm.category_revenue,
    cm.category_quantity,
    cm.category_transactions,
    mc.monthly_revenue,
    mc.monthly_quantity,
    mc.monthly_transactions,
    round(cm.category_revenue / nullif(mc.monthly_revenue, 0) * 100, 2) as contribution_pct,
    mc.previous_month_revenue,
    mc.monthly_revenue - mc.previous_month_revenue as revenue_change,
    round(
        (mc.monthly_revenue - mc.previous_month_revenue)
        / nullif(mc.previous_month_revenue, 0) * 100,
        2
    ) as growth_rate_pct,
    mc.data_through_date,
    case
        when mc.SalesMonth = strftime(ls.latest_sales_date, '%Y-%m')
            and mc.data_through_date < last_day(mc.data_through_date)
            then true
        else false
    end as is_partial_month
from category_month cm
join monthly_change mc
    on cm.SalesMonth = mc.SalesMonth
cross join latest_sale ls
