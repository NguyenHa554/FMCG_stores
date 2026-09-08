with thresholds as (
    select
        avg(avg_order_value) as avg_aov_threshold,
        avg(total_transactions) as avg_frequency_threshold
    from {{ ref('customer_behavior_summary') }}
)

select
    cbs.CustomerID,
    cbs.CustomerName,
    cbs.CityName,
    cbs.CountryName,
    cbs.total_transactions,
    cbs.total_quantity,
    cbs.total_revenue,
    cbs.avg_quantity_per_transaction,
    cbs.avg_order_value,
    cbs.first_purchase_date,
    cbs.last_purchase_date,
    case
        when cbs.avg_order_value >= t.avg_aov_threshold
             and cbs.total_transactions >= t.avg_frequency_threshold
            then 'VIP Customers'

        when cbs.avg_order_value >= t.avg_aov_threshold
             and cbs.total_transactions < t.avg_frequency_threshold
            then 'Premium Occasional Customers'

        when cbs.avg_order_value < t.avg_aov_threshold
             and cbs.total_transactions >= t.avg_frequency_threshold
            then 'Loyal Low-Value Customers'

        else 'Regular Customers'
    end as customer_segment
from {{ ref('customer_behavior_summary') }} cbs
cross join thresholds t
