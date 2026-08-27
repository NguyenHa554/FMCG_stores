DROP TABLE IF EXISTS geographic_revenue_with_region;

CREATE TABLE geographic_revenue_with_region (
    CityName VARCHAR(45) NOT NULL,
    CountryName VARCHAR(45) NOT NULL,
    USRegion VARCHAR(20) NOT NULL,
    total_customers BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    revenue_per_customer DECIMAL(18,4) NOT NULL,
    transactions_per_customer DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (CityName, CountryName),
    INDEX idx_geo_region (USRegion),
    INDEX idx_geo_region_revenue (USRegion, total_revenue),
    INDEX idx_geo_region_quantity (USRegion, total_quantity)
);

INSERT INTO geographic_revenue_with_region (
    CityName,
    CountryName,
    USRegion,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
)
SELECT
    CityName,
    CountryName,
    CASE
        WHEN CityName IN (
            'Albuquerque', 'Anaheim', 'Anchorage', 'Aurora', 'Bakersfield',
            'Colorado', 'Denver', 'Fremont', 'Fresno', 'Glendale',
            'Honolulu', 'Las Vegas', 'Long Beach', 'Los Angeles', 'Mesa',
            'Oakland', 'Phoenix', 'Portland', 'Riverside', 'Sacramento',
            'San Diego', 'San Francisco', 'San Jose', 'Santa Ana',
            'Seattle', 'Spokane', 'Stockton', 'Tacoma', 'Tucson'
        ) THEN 'West'

        WHEN CityName IN (
            'Akron', 'Chicago', 'Cincinnati', 'Cleveland', 'Columbus',
            'Dayton', 'Des Moines', 'Detroit', 'Fort Wayne', 'Grand Rapids',
            'Indianapolis', 'Kansas', 'Lincoln', 'Madison', 'Milwaukee',
            'Minneapolis', 'Omaha', 'St. Louis', 'St. Paul', 'Toledo',
            'Wichita'
        ) THEN 'Midwest'

        WHEN CityName IN (
            'Arlington', 'Atlanta', 'Austin', 'Baton Rouge', 'Birmingham',
            'Charlotte', 'Corpus Christi', 'Dallas', 'El Paso', 'Fort Worth',
            'Garland', 'Greensboro', 'Hialeah', 'Houston', 'Jackson',
            'Jacksonville', 'Little Rock', 'Louisville', 'Lubbock', 'Memphis',
            'Miami', 'Mobile', 'Montgomery', 'Nashville', 'New Orleans',
            'Norfolk', 'Oklahoma', 'Raleigh', 'Richmond', 'San Antonio',
            'Shreveport', 'St. Petersburg', 'Tampa', 'Tulsa', 'Virginia Beach'
        ) THEN 'South'

        WHEN CityName IN (
            'Baltimore', 'Boston', 'Buffalo', 'Jersey', 'New York', 'Newark',
            'Philadelphia', 'Pittsburgh', 'Rochester', 'Washington', 'Yonkers'
        ) THEN 'Northeast'

        ELSE 'Other / Unknown'
    END AS USRegion,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
FROM geographic_revenue_summary;

DROP TABLE IF EXISTS geographic_region_summary;

CREATE TABLE geographic_region_summary (
    USRegion VARCHAR(20) NOT NULL,
    total_cities BIGINT NOT NULL,
    total_customers BIGINT NOT NULL,
    total_transactions BIGINT NOT NULL,
    total_quantity BIGINT NOT NULL,
    total_revenue DECIMAL(24,4) NOT NULL,
    revenue_share_pct DECIMAL(10,4) NOT NULL,
    avg_revenue_per_transaction DECIMAL(18,4) NOT NULL,
    avg_quantity_per_transaction DECIMAL(18,4) NOT NULL,
    revenue_per_customer DECIMAL(18,4) NOT NULL,
    transactions_per_customer DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (USRegion),
    INDEX idx_region_revenue (total_revenue),
    INDEX idx_region_quantity (total_quantity),
    INDEX idx_region_customers (total_customers)
);

INSERT INTO geographic_region_summary (
    USRegion,
    total_cities,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    revenue_share_pct,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
)
WITH region_agg AS (
    SELECT
        USRegion,
        COUNT(*) AS total_cities,
        SUM(total_customers) AS total_customers,
        SUM(total_transactions) AS total_transactions,
        SUM(total_quantity) AS total_quantity,
        SUM(total_revenue) AS total_revenue
    FROM geographic_revenue_with_region
    GROUP BY USRegion
),
grand_total AS (
    SELECT SUM(total_revenue) AS all_region_revenue
    FROM region_agg
)
SELECT
    ra.USRegion,
    ra.total_cities,
    ra.total_customers,
    ra.total_transactions,
    ra.total_quantity,
    ROUND(ra.total_revenue, 4) AS total_revenue,
    ROUND(ra.total_revenue / NULLIF(gt.all_region_revenue, 0) * 100, 4) AS revenue_share_pct,
    ROUND(ra.total_revenue / NULLIF(ra.total_transactions, 0), 4) AS avg_revenue_per_transaction,
    ROUND(ra.total_quantity / NULLIF(ra.total_transactions, 0), 4) AS avg_quantity_per_transaction,
    ROUND(ra.total_revenue / NULLIF(ra.total_customers, 0), 4) AS revenue_per_customer,
    ROUND(ra.total_transactions / NULLIF(ra.total_customers, 0), 4) AS transactions_per_customer
FROM region_agg ra
CROSS JOIN grand_total gt;
