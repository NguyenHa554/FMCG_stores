
    
    

select
    customer_type as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`customer_repeat_summary`
where customer_type is not null
group by customer_type
having count(*) > 1


