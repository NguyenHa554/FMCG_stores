
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    customer_type as unique_field,
    count(*) as n_records

from "fmcg"."main"."customer_repeat_summary"
where customer_type is not null
group by customer_type
having count(*) > 1



  
  
      
    ) dbt_internal_test