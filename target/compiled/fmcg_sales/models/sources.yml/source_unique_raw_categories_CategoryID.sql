
    
    

select
    CategoryID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`categories`
where CategoryID is not null
group by CategoryID
having count(*) > 1


