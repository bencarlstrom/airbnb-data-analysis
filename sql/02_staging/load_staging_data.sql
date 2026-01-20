/*
 *  This script inserts data into the staging tables from the raw tables and performs some basic cleaning
 *  Run it anytime to rebuild staging tables from the raw data
 */

TRUNCATE staging.listings;
INSERT INTO staging.listings
SELECT
    id
    , listing_url
    , scrape_id
    , last_scraped
    , source
    , name
    , description
    , neighborhood_overview
    , picture_url
    , host_id
    , host_url
    , host_name
    , host_since
    , host_location
    , host_about
    , host_response_time
    , CAST(NULLIF(REGEXP_REPLACE(host_response_rate, '[^0-9]', '', 'g'), '') AS int) AS host_response_rate
    , CAST(NULLIF(REGEXP_REPLACE(host_acceptance_rate, '[^0-9]', '', 'g'), '') AS int) AS host_acceptance_rate
    , CASE
        WHEN host_is_superhost = 't' THEN TRUE
        WHEN host_is_superhost = 'f' THEN FALSE
    END AS host_is_superhost
    , host_thumbnail_url
    , host_picture_url
    , host_neighborhood
    , host_listings_count
    , host_total_listings_count
    , host_verifications
    , CASE
        WHEN host_has_profile_pic = 't' THEN TRUE
        WHEN host_has_profile_pic = 'f' THEN FALSE
    END AS host_has_profile_pic
    , CASE
        WHEN host_identity_verified = 't' THEN TRUE
        WHEN host_identity_verified = 'f' THEN FALSE
    END AS host_identity_verified
    , neighborhood
    , neighborhood_cleansed
    , neighborhood_group_cleansed
    , latitude
    , longitude
    , property_type
    , room_type
    , accommodates
    , bathrooms
    , bathrooms_text
    , CASE
        WHEN bathrooms_text ILIKE '%half-bath%' THEN 0.5
        ELSE CAST(NULLIF(REGEXP_REPLACE(bathrooms_text, '[^0-9.]', '', 'g'), '') AS numeric)
    END AS bathrooms_count
    , bedrooms
    , beds
    , amenities
    , CAST(NULLIF(REGEXP_REPLACE(price, '[^0-9.]', '', 'g'), '') AS numeric) AS price
    , minimum_nights
    , maximum_nights
    , minimum_minimum_nights
    , maximum_minimum_nights
    , minimum_maximum_nights
    , maximum_maximum_nights
    , minimum_nights_avg_ntm
    , maximum_nights_avg_ntm
    , calendar_updated
    , CASE
        WHEN has_availability = 't' THEN TRUE
        WHEN has_availability = 'f' THEN FALSE
    END AS has_availability
    , availability_30
    , availability_60
    , availability_90
    , availability_365
    , calendar_last_scraped
    , number_of_reviews
    , number_of_reviews_ltm
    , number_of_reviews_l30d
    , first_review
    , last_review
    , review_scores_rating
    , review_scores_accuracy
    , review_scores_cleanliness
    , review_scores_checkin
    , review_scores_communication
    , review_scores_location
    , review_scores_value
    , license
    , CASE
        WHEN instant_bookable = 't' THEN TRUE
        WHEN instant_bookable = 'f' THEN FALSE
    END AS instant_bookable
    , calculated_host_listings_count
    , calculated_host_listings_count_entire_homes
    , calculated_host_listings_count_private_rooms
    , calculated_host_listings_count_shared_rooms
    , reviews_per_month
FROM raw.listings;

TRUNCATE staging.reviews;
INSERT INTO staging.reviews
SELECT
    listings_id
    , id
    , date
    , reviewer_id
    , reviewer_name
    , comments
FROM raw.reviews;