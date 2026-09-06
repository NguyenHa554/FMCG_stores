
  
    

  create  table
    `sales_of_fmcg_stores`.`monthly_revenue_change__dbt_tmp`
    
    
      as
    
    (
      with monthly_revenue as (
    select
        SalesMonth,
        sum(Revenue) as total_revenue
    from `sales_of_fmcg_stores`.`int_sales_enriched`
    where SalesDate is not null
    group by SalesMonth
)

select
    SalesMonth,
    total_revenue,
    lag(total_revenue) over (order by SalesMonth) as previous_month_revenue,
    total_revenue - lag(total_revenue) over (order by SalesMonth) as revenue_change,
    round(
        (total_revenue - lag(total_revenue) over (order by SalesMonth))
        / nullif(lag(total_revenue) over (order by SalesMonth), 0) * 100,
        2
    ) as growth_rate_pct
from monthly_revenue
    )

  