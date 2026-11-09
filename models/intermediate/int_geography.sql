{{ config(materialized='view') }}

with city_metrics as (
    select
        CityID,
        CityName,
        CountryID,
        CountryName,
        count(*) as total_customers,
        sum(total_transactions) as total_transactions,
        sum(total_quantity) as total_quantity,
        round(sum(total_revenue), 4) as total_revenue
    from {{ ref('int_customer') }}
    group by
        CityID,
        CityName,
        CountryID,
        CountryName
)

select
    CityID,
    CityName,
    CountryID,
    CountryName,
    case
        when CityName in (
            'Albuquerque', 'Anaheim', 'Anchorage', 'Aurora', 'Bakersfield',
            'Colorado', 'Denver', 'Fremont', 'Fresno', 'Glendale',
            'Honolulu', 'Las Vegas', 'Long Beach', 'Los Angeles', 'Mesa',
            'Oakland', 'Phoenix', 'Portland', 'Riverside', 'Sacramento',
            'San Diego', 'San Francisco', 'San Jose', 'Santa Ana',
            'Seattle', 'Spokane', 'Stockton', 'Tacoma', 'Tucson'
        ) then 'West'
        when CityName in (
            'Akron', 'Chicago', 'Cincinnati', 'Cleveland', 'Columbus',
            'Dayton', 'Des Moines', 'Detroit', 'Fort Wayne', 'Grand Rapids',
            'Indianapolis', 'Kansas', 'Lincoln', 'Madison', 'Milwaukee',
            'Minneapolis', 'Omaha', 'St. Louis', 'St. Paul', 'Toledo',
            'Wichita'
        ) then 'Midwest'
        when CityName in (
            'Arlington', 'Atlanta', 'Austin', 'Baton Rouge', 'Birmingham',
            'Charlotte', 'Corpus Christi', 'Dallas', 'El Paso', 'Fort Worth',
            'Garland', 'Greensboro', 'Hialeah', 'Houston', 'Jackson',
            'Jacksonville', 'Little Rock', 'Louisville', 'Lubbock', 'Memphis',
            'Miami', 'Mobile', 'Montgomery', 'Nashville', 'New Orleans',
            'Norfolk', 'Oklahoma', 'Raleigh', 'Richmond', 'San Antonio',
            'Shreveport', 'St. Petersburg', 'Tampa', 'Tulsa', 'Virginia Beach'
        ) then 'South'
        when CityName in (
            'Baltimore', 'Boston', 'Buffalo', 'Jersey', 'New York', 'Newark',
            'Philadelphia', 'Pittsburgh', 'Rochester', 'Washington', 'Yonkers'
        ) then 'Northeast'
        else 'Other / Unknown'
    end as USRegion,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    round(total_revenue / nullif(total_transactions, 0), 4) as avg_revenue_per_transaction,
    round(total_quantity / nullif(total_transactions, 0), 4) as avg_quantity_per_transaction,
    round(total_revenue / nullif(total_customers, 0), 4) as revenue_per_customer,
    round(total_transactions / nullif(total_customers, 0), 4) as transactions_per_customer
from city_metrics
