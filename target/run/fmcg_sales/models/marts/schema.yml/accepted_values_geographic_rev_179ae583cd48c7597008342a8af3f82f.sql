
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        USRegion as value_field,
        count(*) as n_records

    from "fmcg"."main"."geographic_revenue_with_region"
    group by USRegion

)

select *
from all_values
where value_field not in (
    'West','Midwest','South','Northeast','Other / Unknown'
)



  
  
      
    ) dbt_internal_test