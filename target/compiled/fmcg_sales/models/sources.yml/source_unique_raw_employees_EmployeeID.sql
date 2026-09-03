
    
    

select
    EmployeeID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`employees`
where EmployeeID is not null
group by EmployeeID
having count(*) > 1


