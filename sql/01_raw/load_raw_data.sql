\copy raw.listings FROM 'data/listings.csv' DELIMITER ',' CSV HEADER;
\copy raw.reviews FROM 'data/reviews.csv' DELIMITER ',' CSV HEADER;