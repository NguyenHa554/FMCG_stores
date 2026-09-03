-- NOTE: avg_revenue_per_transaction divides by count(*) (the number of months
-- per salesperson), matching sql/4.2.salesperson_performance_summary.sql so the
-- dbt output can be diffed against the existing MySQL table. Divide by
-- sum(total_transactions) instead to make the metric match its name.
select
    SalesPersonName,
    SalesPersonID,
    sum(total_transactions) as total_transactions,
    sum(total_quantity) as total_quantity,
    sum(total_revenue) as total_revenue,
    round(sum(total_revenue) / nullif(count(*), 0), 4) as avg_revenue_per_transaction
from {{ ref('salesperson_monthly_summary') }}
group by
    SalesPersonID,
    SalesPersonName
