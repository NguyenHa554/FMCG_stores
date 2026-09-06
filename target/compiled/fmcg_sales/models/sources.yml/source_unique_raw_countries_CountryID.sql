
    
    

select
    CountryID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."countries"
where CountryID is not null
group by CountryID
having count(*) > 1


