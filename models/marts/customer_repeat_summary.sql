with typed_customers as (
    select
        case
            when total_transactions > 1 then 'Repeat Customers'
            else 'One-time Buyers'
        end as customer_type,
        total_revenue
    from {{ ref('customer_behavior_summary') }}
)

select
    customer_type,
    count(*) as customer_count,
    sum(total_revenue) as total_revenue,
    round(avg(total_revenue), 2) as avg_revenue_per_customer
from typed_customers
group by customer_type
