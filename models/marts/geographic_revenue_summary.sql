select
    CityName,
    CountryName,
    count(*) as total_customers,
    sum(total_transactions) as total_transactions,
    sum(total_quantity) as total_quantity,
    round(sum(total_revenue), 4) as total_revenue,
    round(sum(total_revenue) / nullif(sum(total_transactions), 0), 4) as avg_revenue_per_transaction,
    round(sum(total_quantity) / nullif(sum(total_transactions), 0), 4) as avg_quantity_per_transaction,
    round(sum(total_revenue) / nullif(count(*), 0), 4) as revenue_per_customer,
    round(sum(total_transactions) / nullif(count(*), 0), 4) as transactions_per_customer
from {{ ref('customer_behavior_summary') }}
group by
    CityName,
    CountryName
