with region_agg as (
    select
        USRegion,
        count(*) as total_cities,
        sum(total_customers) as total_customers,
        sum(total_transactions) as total_transactions,
        sum(total_quantity) as total_quantity,
        sum(total_revenue) as total_revenue
    from {{ ref('geographic_revenue_with_region') }}
    group by USRegion
),

grand_total as (
    select sum(total_revenue) as all_region_revenue
    from region_agg
)

select
    ra.USRegion,
    ra.total_cities,
    ra.total_customers,
    ra.total_transactions,
    ra.total_quantity,
    round(ra.total_revenue, 4) as total_revenue,
    round(ra.total_revenue / nullif(gt.all_region_revenue, 0) * 100, 4) as revenue_share_pct,
    round(ra.total_revenue / nullif(ra.total_transactions, 0), 4) as avg_revenue_per_transaction,
    round(ra.total_quantity / nullif(ra.total_transactions, 0), 4) as avg_quantity_per_transaction,
    round(ra.total_revenue / nullif(ra.total_customers, 0), 4) as revenue_per_customer,
    round(ra.total_transactions / nullif(ra.total_customers, 0), 4) as transactions_per_customer
from region_agg ra
cross join grand_total gt
