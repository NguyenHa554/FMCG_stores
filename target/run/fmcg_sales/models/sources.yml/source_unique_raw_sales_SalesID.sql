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
      
    
    

select
    SalesID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`sales`
where SalesID is not null
group by SalesID
having count(*) > 1



      
    ) dbt_internal_test