with customer_sales as (
    select
        CustomerID,
        count(*) as total_transactions,
        sum(Quantity) as total_quantity,
        round(sum(Revenue), 4) as total_revenue,
        round(avg(Quantity), 4) as avg_quantity_per_transaction,
        round(avg(Revenue), 4) as avg_order_value,
        min(SalesDate) as first_purchase_date,
        max(SalesDate) as last_purchase_date
    from {{ ref('int_sales_metrics') }}
    where SalesDate is not null
    group by CustomerID
),

customer_behavior as (
    select
        c.CustomerID,
        c.CustomerName,
        c.CityID,
        c.CityName,
        c.CountryID,
        c.CountryName,
        cs.total_transactions,
        cs.total_quantity,
        cs.total_revenue,
        cs.avg_quantity_per_transaction,
        cs.avg_order_value,
        cs.first_purchase_date,
        cs.last_purchase_date
    from customer_sales cs
    join {{ ref('int_dim_customer') }} c
        on cs.CustomerID = c.CustomerID
),

thresholds as (
    select
        avg(avg_order_value) as avg_aov_threshold,
        avg(total_transactions) as avg_frequency_threshold
    from customer_behavior
)

select
    cb.*,
    case
        when cb.total_transactions > 1 then 'Repeat Customers'
        else 'One-time Buyers'
    end as customer_type,
    case
        when cb.avg_order_value >= t.avg_aov_threshold
            and cb.total_transactions >= t.avg_frequency_threshold
            then 'VIP Customers'
        when cb.avg_order_value >= t.avg_aov_threshold
            and cb.total_transactions < t.avg_frequency_threshold
            then 'Premium Occasional Customers'
        when cb.avg_order_value < t.avg_aov_threshold
            and cb.total_transactions >= t.avg_frequency_threshold
            then 'Loyal Low-Value Customers'
        else 'Regular Customers'
    end as customer_segment
from customer_behavior cb
cross join thresholds t
