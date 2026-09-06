
    
    

select
    CategoryID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."categories"
where CategoryID is not null
group by CategoryID
having count(*) > 1


