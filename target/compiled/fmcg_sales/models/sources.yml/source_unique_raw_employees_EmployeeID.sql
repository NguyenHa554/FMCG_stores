
    
    

select
    EmployeeID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."employees"
where EmployeeID is not null
group by EmployeeID
having count(*) > 1


