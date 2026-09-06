
    
    

select
    ProductID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`product_performance_summary`
where ProductID is not null
group by ProductID
having count(*) > 1


