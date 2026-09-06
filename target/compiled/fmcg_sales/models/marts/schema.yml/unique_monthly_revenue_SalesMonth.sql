
    
    

select
    SalesMonth as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`monthly_revenue`
where SalesMonth is not null
group by SalesMonth
having count(*) > 1


