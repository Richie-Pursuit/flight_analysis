CREATE DATABASE IF NOT EXISTS airline_analysis;
USE airline_analysis;

CREATE TABLE IF NOT EXISTS flight_data (
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

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

USE airline_analysis;

LOAD DATA LOCAL INFILE '/Users/richiec/Downloads/US Airline Flight Routes and Fares 1993-2024.csv'
INTO TABLE flight_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;