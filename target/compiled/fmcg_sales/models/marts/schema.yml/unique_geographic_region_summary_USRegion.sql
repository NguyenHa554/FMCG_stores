
    
    

select
    USRegion as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`geographic_region_summary`
where USRegion is not null
group by USRegion
having count(*) > 1


