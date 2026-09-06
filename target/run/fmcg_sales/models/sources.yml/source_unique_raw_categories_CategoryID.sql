
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    CategoryID as unique_field,
    count(*) as n_records

from "fmcg"."raw"."categories"
where CategoryID is not null
group by CategoryID
having count(*) > 1



  
  
      
    ) dbt_internal_test