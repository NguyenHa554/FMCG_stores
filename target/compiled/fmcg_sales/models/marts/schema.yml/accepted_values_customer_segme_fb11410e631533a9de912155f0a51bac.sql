
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from `sales_of_fmcg_stores`.`customer_segment_summary`
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'VIP Customers','Premium Occasional Customers','Loyal Low-Value Customers','Regular Customers'
)


