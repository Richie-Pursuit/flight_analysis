-- Creating a table to group passenger counts by fare ranges
CREATE TABLE IF NOT EXISTS fare_passenger_analysis AS
SELECT 
    CASE 
        WHEN fare < 50 THEN 'Under $50'
        WHEN fare BETWEEN 50 AND 100 THEN '$50-$100'
        WHEN fare BETWEEN 100 AND 200 THEN '$100-$200'
        WHEN fare BETWEEN 200 AND 300 THEN '$200-$300'
        WHEN fare BETWEEN 300 AND 400 THEN '$300-$400'
        ELSE 'Over $400'
    END AS fare_range,
    SUM(passengers) AS total_passengers,
    COUNT(*) AS number_of_trips
FROM flight_data_staging
GROUP BY fare_range;


-- Creating a table to analyze passenger count and average fare between city pairs
CREATE TABLE IF NOT EXISTS city_pair_analysis AS
SELECT 
    city1, 
    city2, 
    AVG(fare) AS avg_fare, 
    SUM(passengers) AS total_passengers,
    COUNT(*) AS number_of_trips
FROM flight_data_staging
GROUP BY city1, city2;


-- Creating a table to analyze trends in fare and passenger count over time
CREATE TABLE IF NOT EXISTS time_trend_analysis AS
SELECT 
    year, 
    quarter, 
    AVG(fare) AS avg_fare, 
    SUM(passengers) AS total_passengers,
    COUNT(*) AS number_of_trips
FROM flight_data_staging
GROUP BY year, quarter;

-- Creating a table to identify top routes by passenger count
CREATE TABLE IF NOT EXISTS top_routes AS
SELECT 
    city1, 
    city2, 
    SUM(passengers) AS total_passengers,
    AVG(fare) AS avg_fare,
    COUNT(*) AS number_of_trips
FROM flight_data_staging
GROUP BY city1, city2
ORDER BY total_passengers DESC
LIMIT 10;

-- Creating a table to calculate total sales by year
CREATE TABLE IF NOT EXISTS yearly_sales AS
SELECT 
    year,
    SUM(fare * passengers) AS total_sales
FROM flight_data_staging
GROUP BY year
ORDER BY year;


-- Creating a table to calculate year-over-year growth in sales
CREATE TABLE IF NOT EXISTS sales_growth AS
SELECT 
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY year)) / LAG(total_sales) OVER (ORDER BY year) * 100 AS growth_rate
FROM yearly_sales;



-- Creating a new table for the summary of flights by year and average price
CREATE TABLE IF NOT EXISTS flight_summary_by_year AS
SELECT 
    year,
    COUNT(*) AS total_flights,
    AVG(fare) AS avg_price
FROM flight_data_staging
GROUP BY year
ORDER BY year;

-- Selecting data from the newly created summary table
SELECT * 
FROM flight_summary_by_year;
