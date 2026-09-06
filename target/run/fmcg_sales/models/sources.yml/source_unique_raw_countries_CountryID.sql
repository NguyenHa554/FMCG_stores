
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    CountryID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."countries"
where CountryID is not null
group by CountryID
having count(*) > 1



  
  
      
    ) dbt_internal_test