
    
    

select
    ProductID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."products"
where ProductID is not null
group by ProductID
having count(*) > 1


