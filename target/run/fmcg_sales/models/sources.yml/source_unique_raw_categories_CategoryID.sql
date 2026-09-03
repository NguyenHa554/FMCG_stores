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
    CategoryID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`categories`
where CategoryID is not null
group by CategoryID
having count(*) > 1



      
    ) dbt_internal_test