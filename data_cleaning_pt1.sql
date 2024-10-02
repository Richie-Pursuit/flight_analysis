SELECT COUNT(*) FROM flight_data WHERE geocoded_city1 LIKE "";

WITH Geocoded_Cities AS (
    SELECT city1, geocoded_city1
    FROM flight_data
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
    GROUP BY city1, geocoded_city1
)
UPDATE flight_data fd
JOIN Geocoded_Cities gc ON fd.city1 = gc.city1
SET fd.geocoded_city1 = gc.geocoded_city1
WHERE fd.geocoded_city1 = ''; -- Only updating empty values

WITH Geocoded_Airports AS (
    SELECT airport_1, geocoded_city1
    FROM flight_data
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
    GROUP BY airport_1, geocoded_city1
)
UPDATE flight_data fd
JOIN Geocoded_Airports ga ON fd.airport_1 = ga.airport_1
SET fd.geocoded_city1 = ga.geocoded_city1
WHERE fd.geocoded_city1 = ''; -- Only updating empty values



SELECT * 
FROM flight_data
WHERE airport_1 LIKE 'ABQ';


-- ----------------------- geocodedcity2

WITH Geocoded_Cities2 AS (
    SELECT city2, geocoded_city2
    FROM flight_data
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
    GROUP BY city2, geocoded_city2
)
UPDATE flight_data fd
JOIN Geocoded_Cities2 gct ON fd.city2 = gct.city2
SET fd.geocoded_city2 = gct.geocoded_city2
WHERE fd.geocoded_city2 = ''; -- Only updating empty values


WITH Geocoded_Airports2 AS (
    SELECT airport_2, geocoded_city2
    FROM flight_data
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
    GROUP BY airport_2, geocoded_city2
)
UPDATE flight_data fd
JOIN Geocoded_Airports2 gat ON fd.airport_2 = gat.airport_2
SET fd.geocoded_city2 = gat.geocoded_city2
WHERE fd.geocoded_city2 = ''; -- Only updating empty values

-- ----- filling in datat that geocoded_city1 has that is missing in 2
WITH Geocoded_Cities3 AS (
    SELECT DISTINCT city1, geocoded_city1
    FROM flight_data
    WHERE geocoded_city1 <> '' -- Selecting only non-empty values
)
UPDATE flight_data fd
JOIN Geocoded_Cities3 gc ON fd.city2 = gc.city1
SET fd.geocoded_city2 = gc.geocoded_city1
WHERE fd.geocoded_city2 = ''; -- Only updating empty values

-- --------------- filling in datat that geocoded_city2 has that is missing in 
WITH Geocoded_Cities4 AS (
    SELECT DISTINCT city2, geocoded_city2
    FROM flight_data
    WHERE geocoded_city2 <> '' -- Selecting only non-empty values
)
UPDATE flight_data fd
JOIN Geocoded_Cities4 gc ON fd.city1 = gc.city2
SET fd.geocoded_city1 = gc.geocoded_city2
WHERE fd.geocoded_city1 = ''; -- Only updating empty values

SELECT *
FROM flight_data
WHERE geocoded_city2 LIKE '';


