select
    CityName,
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
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
from {{ ref('geographic_revenue_summary') }}
