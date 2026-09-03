select
    c.CustomerID,
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
    ci.CityName,
    co.CountryName,
    sca.total_transactions,
    sca.total_quantity,
    sca.total_revenue,
    sca.avg_quantity_per_transaction,
    sca.avg_order_value,
    sca.first_purchase_date,
    sca.last_purchase_date
from {{ ref('sales_customer_agg') }} sca
join {{ ref('stg_customers') }} c
    on sca.CustomerID = c.CustomerID
join {{ ref('stg_cities') }} ci
    on c.CityID = ci.CityID
join {{ ref('stg_countries') }} co
    on ci.CountryID = co.CountryID
