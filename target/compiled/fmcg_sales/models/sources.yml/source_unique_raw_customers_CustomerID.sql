
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."customers"
where CustomerID is not null
group by CustomerID
having count(*) > 1


