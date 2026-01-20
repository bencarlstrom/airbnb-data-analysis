/*
 * Business analysis queries for Airbnb Mexico City data
 * Source: Inside Airbnb, December 2023
 */

-- 1. Neighborhoods most impacted by Airbnb (per capita listings)
-- Top three: Cuauhtémoc, Miguel Hidalgo, Benito Juárez
SELECT
    n.neighborhood,
    ROUND(CAST(COUNT(*) AS NUMERIC) / n.population, 5) AS per_capita_bnbs
FROM clean.listings l
    JOIN clean.neighborhoods n ON l.neighborhood = n.pk
WHERE n.population IS NOT NULL
GROUP BY n.neighborhood, n.population
ORDER BY per_capita_bnbs DESC;


-- 2. Highest rated neighborhoods by location score
-- Top three: Cuauhtémoc, Miguel Hidalgo, Benito Juárez
DROP VIEW IF EXISTS top_rated_neighborhoods;
CREATE VIEW top_rated_neighborhoods AS
SELECT
    n.neighborhood,
    ROUND(AVG(rd.review_scores_location), 2) AS average_location_rating,
    COUNT(*) AS listings_with_scores
FROM clean.listings l
    JOIN clean.neighborhoods n ON l.neighborhood = n.pk
    JOIN clean.review_data rd ON l.id = rd.listing_id
WHERE rd.review_scores_location IS NOT NULL
GROUP BY n.neighborhood
ORDER BY average_location_rating DESC;
SELECT * FROM top_rated_neighborhoods;


-- 3. Most expensive neighborhoods by average price
-- Top three: Gustavo Madero, Miguel Hidalgo, Cuauhtémoc
DROP VIEW IF EXISTS most_expensive_neighborhoods;
CREATE VIEW most_expensive_neighborhoods AS
SELECT
    n.neighborhood,
    ROUND(AVG(l.price), 2) AS avg_price,
    COUNT(*) AS listings_counted
FROM clean.listings l
    JOIN clean.neighborhoods n ON l.neighborhood = n.pk
    JOIN clean.review_data rd ON l.id = rd.listing_id
WHERE rd.number_of_reviews > 0
    AND l.price IS NOT NULL
GROUP BY n.neighborhood
ORDER BY avg_price DESC;
SELECT * FROM most_expensive_neighborhoods;


-- 4. Are average location rating by neighborhood and average price by neighborhood correlated?
-- The coefficient of 0.41 indicates a moderate positive correlation between price and location rating
-- In other words, neighborhoods with higher location ratings tend to have higher prices
SELECT CORR(trn.average_location_rating, men.avg_price) AS price_location_corr
FROM top_rated_neighborhoods trn
JOIN most_expensive_neighborhoods men ON trn.neighborhood = men.neighborhood;


-- 5. Which listings have the highest potential monthly revenue?
DROP VIEW IF EXISTS top_revenue_airbnbs;
CREATE VIEW top_revenue_airbnbs AS
SELECT
    l.id,
    l.name,
    h.host_name,
    (l.price * 30) AS monthly_revenue
FROM clean.listings l
    JOIN clean.hosts h USING (host_id)
    JOIN clean.availability a ON l.id = a.listing_id
WHERE l.price > 0
    AND l.price < 50000  -- Excludes extreme outliers (e.g. $104k USD per night private room)
    AND a.minimum_nights < 31
ORDER BY monthly_revenue DESC;
SELECT * FROM top_revenue_airbnbs;


-- 6. Which hosts generate the most potential monthly revenue?
DROP VIEW IF EXISTS host_monthly_revenue;
CREATE VIEW host_monthly_revenue AS
SELECT
    h.host_id,
    h.host_name,
    SUM(l.price * 30) AS monthly_revenue,
    h.calculated_host_listings_count
FROM clean.listings l
    JOIN clean.hosts h USING (host_id)
    JOIN clean.availability a ON l.id = a.listing_id
WHERE l.price > 0
    AND l.price < 50000  -- Excludes extreme outliers (e.g. $104k USD per night private room)
    AND a.minimum_nights < 31
GROUP BY h.host_id, h.host_name, h.calculated_host_listings_count
ORDER BY monthly_revenue DESC;
SELECT * FROM host_monthly_revenue;


-- 7. Which ratings correlate most strongly with customer's value rating?
-- In other words, what do customers feel is most strongly associated with value?
-- Accuracy
SELECT
    'accuracy' AS review_type,
    CORR(review_scores_accuracy, review_scores_value) AS correlation_coefficient
FROM clean.review_data

UNION ALL

SELECT
    'cleanliness' AS review_type,
    CORR(review_scores_cleanliness, review_scores_value) AS correlation_coefficient
FROM clean.review_data

UNION ALL

SELECT
    'checkin' AS review_type,
    CORR(review_scores_checkin, review_scores_value) AS correlation_coefficient
FROM clean.review_data

UNION ALL

SELECT
    'communication' AS review_type,
    CORR(review_scores_communication, review_scores_value) AS correlation_coefficient
FROM clean.review_data

UNION ALL

SELECT
    'location' AS review_type,
    CORR(review_scores_location, review_scores_value) AS correlation_coefficient
FROM clean.review_data

ORDER BY correlation_coefficient DESC;
