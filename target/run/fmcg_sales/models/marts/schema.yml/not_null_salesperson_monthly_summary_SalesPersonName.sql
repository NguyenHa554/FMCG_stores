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
      
    
    



select SalesPersonName
from `sales_of_fmcg_stores`.`salesperson_monthly_summary`
where SalesPersonName is null



      
    ) dbt_internal_test