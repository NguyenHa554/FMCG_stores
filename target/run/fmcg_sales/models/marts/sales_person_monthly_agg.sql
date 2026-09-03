
  
    

  create  table
    `sales_of_fmcg_stores`.`sales_person_monthly_agg__dbt_tmp`
    
    
      as
    
    (
      select
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    s.SalesPersonID,
    count(*) as total_transactions,
    sum(s.Quantity) as total_quantity,
    round(sum(s.Quantity * p.Price * (1 - s.Discount)), 4) as total_revenue,
    round(
        sum(s.Quantity * p.Price * (1 - s.Discount)) / nullif(count(*), 0),
        4
    ) as avg_revenue_per_transaction
from `sales_of_fmcg_stores`.`stg_sales` s
join `sales_of_fmcg_stores`.`stg_products` p
    on s.ProductID = p.ProductID
where s.SalesDate is not null
group by
    date_format(s.SalesDate, '%Y-%m'),
    s.SalesPersonID
    )

  