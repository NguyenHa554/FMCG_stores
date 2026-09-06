
    
    

select
    SalesID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."sales"
where SalesID is not null
group by SalesID
having count(*) > 1


