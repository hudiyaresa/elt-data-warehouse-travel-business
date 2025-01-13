# ELT Pipeline Orhcestration - Pactravel Data Warehouse

## Overview
This project implements a Data Warehouse (DWH) for Pactravel, designed to enhance data analysis capabilities for better strategic decision-making. It utilizes Slowly Changing Dimensions (SCD) strategies and an ELT pipeline with DBT, Python, SQL, and Luigi for orchestration. The final output provides enriched insights into daily booking volumes and revenue trends.

## Table of Contents
1. [Overview](#overview)
2. [Requirements Gathering](#requirements-gathering)
3. [Slowly Changing Dimension (SCD)](#slowly-changing-dimension-scd)
   1. [Strategy](#strategy)
4. [ELT with Python & SQL](#elt-with-python--sql)
   1. [Workflow Description](#workflow-description)
   2. [Setup and Execution](#setup-and-execution)
   3. [Code Highlights](#code-highlights)
5. [Orchestrate ELT with Luigi](#orchestrate-elt-with-luigi)
   1. [Setup Instructions](#setup-instructions)
6. [Requirements](#requirements)
7. [Results](#results)
8. [References](#references)

## Requirements Gathering
### Key Questions and Answers
1. **What is the primary objective of the data warehouse for this project?**  
   To provide a centralized system for tracking daily booking volumes (for both flight and hotel bookings) and monitoring average ticket prices over time.
2. **What dimensions are important for analyzing daily booking volumes?**  
   Date, customer demographics, airport details, airline, and hotel details.
3. **What level of granularity is required for the flight bookings data?**  
   Data should be detailed down to individual bookings, including date, customer, price, and flight details.
4. **Should we implement a Slowly Changing Dimension (SCD) strategy for certain dimensions?**  
   Yes, we will implement SCD Type 2 for dimensions like `dim_customers`, `dim_hotels`, and `dim_airlines`.
5. **How frequently should the data warehouse be updated?**  
   The data warehouse should be updated daily to ensure timely and accurate reporting.
6. **How should historical changes be handled in the data warehouse?**  
   Historical changes should be captured using SCD Type 2 to maintain a full history of data changes.

### Summary
**Point Description:** The travel business currently operates transactionally, with data stored effectively in databases for booking flight and hotel reservations.  
**Problem:** There is no dedicated analytical database to leverage stored data for strategic planning to increase revenue.  
**Solution:**  
1. **Data Warehouse:** Implement a data warehouse to process stored data analytically, revealing patterns, trends, and potential strategies to enhance travel business revenue.
2. **SCD Type 2 Implementation:** Utilize DBT snapshots for SCD Type 2, preserving historical data for deeper analysis.
3. **ELT Pipeline:** Implement an ELT pipeline using Luigi and DBT, including error logging and alerting via Python and Sentry SDK.
4. **Scheduling:** Use cron for scheduling data updates to keep the data warehouse current.

## Slowly Changing Dimension (SCD)
### Strategy
| Dim Tables   | SCD Type | Explanation                                           |
|--------------|----------|-------------------------------------------------------|
| `dim_customers` | Type 2   | Tracks changes in customer details over time.         |
| `dim_hotels`    | Type 2   | Captures historical changes in hotel information.     |
| `dim_airlines`  | Type 2   | Maintains history of airline data changes.            |
| `dim_aircrafts` | Type 1   | Updates data without retaining historical changes.    |
| `dim_airports`  | Type 1   | Stores the most recent data without history.          |

## ERD Source
![ERD Source](img_assets/ERD_Source_.png)

## ERD Final Plan
![ERD Final](img_assets/ERD_Final.png)


## ELT with Python & SQL

![ELT Pipeline](img_assets/ELT_Illustration.png)

### Workflow Description
1. **Extraction:** Data is extracted from PostgreSQL databases using Python and Luigi.
2. **Loading:** Data is loaded into public and staging schemas in the data warehouse.
3. **Transformation:** DBT transforms the data into data marts and the final data warehouse.

### Setup and Execution

### 1. Requirements

- OS :
    - Linux
    - WSL (Windows Subsystem For Linux)
- Tools :
    - Dbeaver
    - Docker
    - Cron
    - DBT
- Programming Language :
    - Python
    - SQL
- Python Libray :
    - Luigi
    - Pandas
    - Sentry-SDK
- Platforms :
    - Sentry

### 2. Preparations
1. Clone the repository (using git lfs clone).
2. Create a `.env` file with the following variables:

```env
# Source
SRC_POSTGRES_DB=olist-src
SRC_POSTGRES_HOST=localhost
SRC_POSTGRES_USER=[YOUR USERNAME]
SRC_POSTGRES_PASSWORD=[YOUR PASSWORD]
SRC_POSTGRES_PORT=[YOUR PORT]

# SENTRY DSN
SENTRY_DSN=... # Fill with your Sentry DSN Project 

# DWH
# Adjust with your directory. make sure to write full path
# Remove comment after each value
DIR_ROOT_PROJECT=... # <project_dir>
DIR_TEMP_LOG=... # <project_dir>/pipeline/temp/log
DIR_TEMP_DATA=... # <project_dir>/pipeline/temp/data
DIR_EXTRACT_QUERY=... # <project_dir>/pipeline/src_query/extract
DIR_LOAD_QUERY=... # <project_dir>/pipeline/src_query/load
DIR_TRANSFORM_QUERY=... # <project_dir>/pipeline/src_query/transform
DIR_LOG=... # <project_dir>/logs/
```

- **Run Data Sources & Data Warehouses** :
  ```
  docker compose up -d
  ```

- **Dataset**
    - Source: Pactravel
    - DWH:
        - staging schema: pactravel
        - final schema: final

3. Ensure the `/helper/source/init.sql` script has the data preloaded.
4. Run `elt_main.py` to execute the pipeline.
5. Monitor logs in the `/logs/logs.log/` directory for any errors.

**Run this command on the background process:**
```bash
luigid --port 8082
```

**To run the pipeline directly from the terminal:**
```bash
python3 elt_main.py
```

**Alternatively, schedule the pipeline using cron to run every hour:**
```bash
0 * * * * <project_dir>/elt_run.sh
```

### Code Highlights
- Use of Python and Luigi for orchestration.
- DBT for data transformation and implementing SCD strategies.

## Orchestrate ELT with Luigi
### Setup Instructions
1. **Python & Luigi:** Install required Python packages and set up Luigi for orchestration.
2. **DBT Models:** Develop DBT models for transforming data into the desired schema.
3. **Cron Scheduling:** Schedule data updates using cron jobs for continuous data flow.

In thats project directory, **create and use virtual environment**.
Then Install dependencies with:
```bash
pip install -r requirements.txt
```

## Results
### Example Queries
To provide insights for the management, you can run the following queries to see the booking trends and pricing strategies:
```sql
-- Daily booking volume by date
SELECT departure_date, COUNT(*) AS total_bookings 
FROM fct_flight_bookings 
GROUP BY departure_date 
ORDER BY departure_date;

-- Average hotel booking price by city
SELECT city, AVG(price) AS avg_price 
FROM fct_hotel_bookings 
GROUP BY city 
ORDER BY avg_price DESC;
```

## References
1. [DBT Documentation](https://docs.getdbt.com/)
2. [Luigi Documentation](https://luigi.readthedocs.io/)
3. [Sentry SDK](https://docs.sentry.io/platforms/python/)