
    
    

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


