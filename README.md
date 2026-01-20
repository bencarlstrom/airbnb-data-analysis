# Airbnb Data Analysis

This PostgreSQL pipeline cleans, validates, and normalizes Mexico City Airbnb listings and reviews data in order to analyze market trends.

The original data used in this project came from quarterly data published December 2023. The CSVs in this repo contain only the first 100 rows of the actual data that was used. Download the full dataset from [Inside Airbnb](http://insideairbnb.com/).

## Instructions

1. Start up Postgres and create the database
```bash
    brew services start postgresql
    psql -d postgres -c "CREATE DATABASE airbnb;"
```

2. Create the database schemas:
```bash
    psql -d airbnb -f sql/00_setup/create_schemas.sql
```

3. Create the raw tables:
```bash
    psql -d airbnb -f sql/01_raw/create_raw_tables.sql
```

4. Load the data into the raw tables (after updating your file path):
```bash
psql -d airbnb -c "\copy raw.listings from '/Users/YOUR_PATH_HERE/airbnb-data-analysis/data/listings_short.csv' delimiter ',' csv header"
psql -d airbnb -c "\copy raw.reviews from '/Users/YOUR_PATH_HERE/airbnb-data-analysis/data/reviews_short.csv' delimiter ',' csv header"
```
On success you should see 'COPY 26760' (listings) and 'COPY 1050473' (reviews)

5. Validate the raw data:
```bash
    psql -d airbnb -f sql/01_raw/validate_raw_data.sql
```

6. Create staging tables, load data, and validate:
```bash
    psql -d airbnb -f sql/02_staging/create_staging_tables.sql
    psql -d airbnb -f sql/02_staging/load_staging_data.sql
    psql -d airbnb -f sql/02_staging/validate_staging_data.sql
```

7. Create clean tables, load data, and validate:
```bash
    psql -d airbnb -f sql/03_clean/create_clean_tables.sql
    psql -d airbnb -f sql/03_clean/load_clean_data.sql
    psql -d airbnb -f sql/03_clean/validate_clean_data.sql
```

8. Run the analysis:
```bash
    psql -d airbnb -f sql/04_analysis/business_questions.sql
```
