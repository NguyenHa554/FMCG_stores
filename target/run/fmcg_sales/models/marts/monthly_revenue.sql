
  
    

  create  table
    `sales_of_fmcg_stores`.`monthly_revenue__dbt_tmp`
    
    
      as
    
    (
      

select
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    sum(s.Quantity * p.Price * (1 - s.Discount)) as Revenue,
    sum(s.Quantity) as Quantity,
    count(*) as Transactions
from `sales_of_fmcg_stores`.`sales` s FORCE INDEX (idx_sales_month_product_metrics)
join `sales_of_fmcg_stores`.`products` p
    on s.ProductID = p.ProductID
where s.SalesDate is not null
group by date_format(s.SalesDate, '%Y-%m')
    )

  