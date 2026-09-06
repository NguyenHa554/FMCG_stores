
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    CityID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."cities"
where CityID is not null
group by CityID
having count(*) > 1



  
  
      
    ) dbt_internal_test