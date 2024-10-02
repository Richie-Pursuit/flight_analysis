CREATE TABLE IF NOT EXISTS flight_data_staging(
	tbl VARCHAR(10),
    year INT,
    quarter INT,
    citymarketid_1 INT,
    citymarketid_2 INT,
    city1 VARCHAR(100),
    city2 VARCHAR(100),
    airportid_1 INT,
    airportid_2 INT,
    airport_1 VARCHAR(10),
    airport_2 VARCHAR(10),
    nsmiles INT,
    passengers INT,
    fare DECIMAL(10, 2),
    carrier_lg VARCHAR(10),
    large_ms DECIMAL(5, 2),
    fare_lg DECIMAL(10, 2),
    carrier_low VARCHAR(10),
    lf_ms DECIMAL(5, 2),
    fare_low DECIMAL(10, 2),
    geocoded_city1 VARCHAR(50),
    geocoded_city2 VARCHAR(50),
    tbl1apk VARCHAR(50)
);

INSERT INTO flight_data_staging
SELECT 
    tbl,
    year,
    quarter,
    citymarketid_1,
    citymarketid_2,
    city1,
    city2,
    airportid_1,
    airportid_2,
    airport_1,
    airport_2,
    nsmiles,
    passengers,
    fare,
    carrier_lg,
    large_ms,
    fare_lg,
    carrier_low,
    lf_ms,
    fare_low,
    geocoded_city1,
    geocoded_city2,
    tbl1apk
FROM flight_data;



WITH Geocoded_Cities AS (
    SELECT city1, geocoded_city1
    FROM flight_data_staging
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
    GROUP BY city1, geocoded_city1
)
UPDATE flight_data_staging fd
JOIN Geocoded_Cities gc ON fd.city1 = gc.city1
SET fd.geocoded_city1 = gc.geocoded_city1
WHERE fd.geocoded_city1 = ''; -- Only updating empty values

WITH Geocoded_Airports AS (
    SELECT airport_1, geocoded_city1
    FROM flight_data_staging
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
    GROUP BY airport_1, geocoded_city1
)
UPDATE flight_data_staging fd
JOIN Geocoded_Airports ga ON fd.airport_1 = ga.airport_1
SET fd.geocoded_city1 = ga.geocoded_city1
WHERE fd.geocoded_city1 = ''; -- Only updating empty values


-- ----------------------- geocodedcity2

WITH Geocoded_Cities2 AS (
    SELECT city2, geocoded_city2
    FROM flight_data_staging
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
    GROUP BY city2, geocoded_city2
)
UPDATE flight_data_staging fd
JOIN Geocoded_Cities2 gct ON fd.city2 = gct.city2
SET fd.geocoded_city2 = gct.geocoded_city2
WHERE fd.geocoded_city2 = ''; -- Only updating empty values


WITH Geocoded_Airports2 AS (
    SELECT airport_2, geocoded_city2
    FROM flight_data_staging
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
    GROUP BY airport_2, geocoded_city2
)
UPDATE flight_data_staging fd
JOIN Geocoded_Airports2 gat ON fd.airport_2 = gat.airport_2
SET fd.geocoded_city2 = gat.geocoded_city2
WHERE fd.geocoded_city2 = ''; -- Only updating empty values

-- ----- filling in datat that geocoded_city1 has that is missing in 2
WITH Geocoded_Cities3 AS (
    SELECT DISTINCT city1, geocoded_city1
    FROM flight_data_staging
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
)
UPDATE flight_data_staging fd
JOIN Geocoded_Cities3 gc ON fd.city2 = gc.city1
SET fd.geocoded_city2 = gc.geocoded_city1
WHERE fd.geocoded_city2 = ''; -- Only updating empty values

-- --------------- filling in datat that geocoded_city2 has that is missing in 
WITH Geocoded_Cities4 AS (
    SELECT DISTINCT city2, geocoded_city2
    FROM flight_data_staging
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
)
UPDATE flight_data_staging fd
JOIN Geocoded_Cities4 gc ON fd.city1 = gc.city2
SET fd.geocoded_city1 = gc.geocoded_city2
WHERE fd.geocoded_city1 = ''; -- Only updating empty values

SELECT COUNT(*)
FROM flight_data_staging;

-- adding new colums for city1 and city2 

ALTER TABLE flight_data_staging
ADD COLUMN departing_city VARCHAR(100),
ADD COLUMN departing_state VARCHAR(100),
ADD COLUMN arriving_city VARCHAR(100),
ADD COLUMN arriving_state VARCHAR(100);

-- Updating city1_name and city1_state
UPDATE flight_data_staging
SET departing_city = SUBSTRING_INDEX(city1, ',', 1), -- Extracting the city
    departing_state = TRIM(SUBSTRING_INDEX(city1, ',', -1)); -- Extracting the state

-- Update city2_name and city2_state
UPDATE flight_data_staging
SET arriving_city = SUBSTRING_INDEX(city2, ',', 1), -- Extracting the city
    arriving_state = TRIM(SUBSTRING_INDEX(city2, ',', -1)); -- Extracting the state
    
-- ----------------------------

-- creating seperate columns for longitude and latitude
ALTER TABLE flight_data_staging
ADD COLUMN dep_city_latitude DECIMAL(10, 8),
ADD COLUMN dep_city_longitude DECIMAL(11, 8),
ADD COLUMN arr_city_latitude DECIMAL(10, 8),
ADD COLUMN arr_city_longitude DECIMAL(11, 8);

UPDATE flight_data_staging
SET 
    geocoded_city1 = NULLIF(geocoded_city1, ''),
    geocoded_city2 = NULLIF(geocoded_city2, '');


-- Set negative fare values to NULL or replace with a default positive value
UPDATE flight_data_staging
SET fare = NULL
WHERE fare < 0;

-- Set negative passenger counts to NULL or replace with a default positive value
UPDATE flight_data_staging
SET passengers = NULL
WHERE passengers < 0;


-- Get a summary of fare and passenger columns to identify outliers
SELECT 
    MIN(fare) AS min_fare, 
    MAX(fare) AS max_fare, 
    AVG(fare) AS avg_fare,
    MIN(passengers) AS min_passengers, 
    MAX(passengers) AS max_passengers, 
    AVG(passengers) AS avg_passengers
FROM flight_data_staging;

SELECT COUNT(*)
FROM flight_data_staging
WHERE passengers = 0;

SELECT *
FROM flight_data_staging
WHERE passengers >0 AND passengers > 600
ORDER BY passengers DESC;
