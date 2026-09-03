select
      count(*) as failures,
      case
        when count(*) <> 0 then 'true'
        else 'false'
      end as should_warn,
      case
        when count(*) <> 0 then 'true'
        else 'false'
      end as should_error
    from (
      
    
    



select SalesMonth
from `sales_of_fmcg_stores`.`sales_person_monthly_agg`
where SalesMonth is null



      
    ) dbt_internal_test