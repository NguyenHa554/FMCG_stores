
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`sales_customer_agg`
where CustomerID is not null
group by CustomerID
having count(*) > 1


