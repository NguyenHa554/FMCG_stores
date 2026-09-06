
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        customer_type as value_field,
        count(*) as n_records

    from "fmcg"."main"."customer_repeat_summary"
    group by customer_type

)

select *
from all_values
where value_field not in (
    'Repeat Customers','One-time Buyers'
)



  
  
      
    ) dbt_internal_test