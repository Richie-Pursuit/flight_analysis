## Flight Analysis Project

This project leverages MySQL to analyze flight data sourced from the Bureau of Transportation Statistics and Kaggle. Using advanced SQL techniques such as Common Table Expressions (CTEs), joins, and aggregations, the data is transformed and explored to uncover insights into flight patterns, airline performance, and airport usage. The analysis aims to provide a comprehensive understanding of trends within the U.S. airline industry.

## Data Sources

The data used in this project is sourced from the Bureau of Transportation Statistics. The following datasets are included:

1. **Airline On-Time Performance Data**: This dataset contains information on domestic flights operated by U.S. airlines, including scheduled and non-scheduled services. It includes details such as flight numbers, origin and destination airports, departure and arrival times, and delays.

2. **Airport Codes**: This dataset contains information about airports in the United States, including their codes, names, cities, and states. It is used to identify the origin and destination airports for flights.

3. **Carriers**: This dataset contains information about airlines operating in the United States, including their codes, names, and abbreviations. It is used to identify the carrier of a flight.

## Project Workflow

1. Data Import (importing_data.sql)
	•	Imported CSV files into SQL tables using bulk loading methods for efficient handling of large datasets.

2. Data Cleaning
	•	Part 1 (data_cleaning_pt1.sql):
	•	Standardized city and airport names for consistency.
	•	Removed duplicates and null values from key columns.
	•	Part 2 (data_cleaning_pt2.sql):
	•	Applied transformations to merge city pairs and airport codes.
	•	Handled outliers 

3. Exploratory Analysis (exploration_queries.sql)
	•	Queried the cleaned dataset to uncover:
	•	Trends in average fare prices.
	•	Top-performing airlines by revenue.
	•	Passenger volumes by route and airport.

