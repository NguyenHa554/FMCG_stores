
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`customer_behavior_summary`
where CustomerID is not null
group by CustomerID
having count(*) > 1


