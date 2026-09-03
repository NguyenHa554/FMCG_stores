
    
    

select
    CityID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`cities`
where CityID is not null
group by CityID
having count(*) > 1


