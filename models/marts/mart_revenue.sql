{{ config(materialized='table') }}

select
    mart_revenue_id,
    SalesMonth,
    CategoryName,
    category_revenue,
    category_quantity,
    category_transactions,
    monthly_revenue,
    monthly_quantity,
    monthly_transactions,
    contribution_pct,
    previous_month_revenue,
    revenue_change,
    growth_rate_pct,
    data_through_date,
    is_partial_month
from {{ ref('int_revenue') }}
