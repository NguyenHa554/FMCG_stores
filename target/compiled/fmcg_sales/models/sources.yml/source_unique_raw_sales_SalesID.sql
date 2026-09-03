
    
    

select
    SalesID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`sales`
where SalesID is not null
group by SalesID
having count(*) > 1


