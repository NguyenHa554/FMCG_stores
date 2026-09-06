
    
    

select
    CityID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."cities"
where CityID is not null
group by CityID
having count(*) > 1


