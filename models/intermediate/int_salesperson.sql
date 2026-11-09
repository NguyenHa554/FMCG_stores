{{ config(materialized='view') }}

with salesperson_month as (
    select
        SalesMonth,
        SalesPersonID,
        count(*) as total_transactions,
        sum(Quantity) as total_quantity,
        round(sum(Revenue), 4) as total_revenue,
        round(sum(Revenue) / nullif(count(*), 0), 4) as avg_revenue_per_transaction
    from {{ ref('int_sales_metrics') }}
    where SalesDate is not null
    group by
        SalesMonth,
        SalesPersonID
)

select
    concat(sm.SalesMonth, '|', cast(sm.SalesPersonID as varchar)) as mart_salesperson_id,
    sm.SalesMonth,
    e.SalesPersonID,
    e.SalesPersonName,
    e.Gender,
    e.HireDate,
    sm.total_transactions,
    sm.total_quantity,
    sm.total_revenue,
    sm.avg_revenue_per_transaction
from salesperson_month sm
join {{ ref('int_dim_salesperson') }} e
    on sm.SalesPersonID = e.SalesPersonID
