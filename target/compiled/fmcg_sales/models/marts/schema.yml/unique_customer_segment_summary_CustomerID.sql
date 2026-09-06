
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from "fmcg"."main"."customer_segment_summary"
where CustomerID is not null
group by CustomerID
having count(*) > 1


