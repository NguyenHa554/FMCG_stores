
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    USRegion as unique_field,
    count(*) as n_records

from "fmcg"."main"."geographic_region_summary"
where USRegion is not null
group by USRegion
having count(*) > 1



  
  
      
    ) dbt_internal_test