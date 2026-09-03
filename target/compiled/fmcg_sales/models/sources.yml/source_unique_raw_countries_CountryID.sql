
    
    

select
    CountryID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`countries`
where CountryID is not null
group by CountryID
having count(*) > 1


