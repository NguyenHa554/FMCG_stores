
    
    

select
    ProductID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`sales_product_agg`
where ProductID is not null
group by ProductID
having count(*) > 1


