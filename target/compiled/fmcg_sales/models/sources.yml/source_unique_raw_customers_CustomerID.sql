
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`customers`
where CustomerID is not null
group by CustomerID
having count(*) > 1


