/*
 * This script creates tables to hold raw data imported from CSVs
 *
 * Data Source: Inside Airbnb - Mexico City, published 26 December, 2023
 * listings.csv contains 26,760 Airbnb listings
 * reviews.csv contains 1,050,473 guest reviews
 *
 */

-- RAW LISTINGS TABLE
DROP TABLE IF EXISTS raw.listings CASCADE;
CREATE TABLE raw.listings (
    id bigint
    , listing_url text
    , scrape_id bigint
    , last_scraped date
    , source text
    , name text
    , description text
    , neighborhood_overview text
    , picture_url text
    , host_id int
    , host_url text
    , host_name text
    , host_since date
    , host_location text
    , host_about text
    , host_response_time text
    , host_response_rate text
    , host_acceptance_rate text
    , host_is_superhost char(1)
    , host_thumbnail_url text
    , host_picture_url text
    , host_neighborhood text
    , host_listings_count int
    , host_total_listings_count int
    , host_verifications text
    , host_has_profile_pic char(1)
    , host_identity_verified char(1)
    , neighborhood text
    , neighborhood_cleansed text
    , neighborhood_group_cleansed text
    , latitude double precision
    , longitude double precision
    , property_type text
    , room_type text
    , accommodates int
    , bathrooms int
    , bathrooms_text text
    , bedrooms int
    , beds int
    , amenities text
    , price text
    , minimum_nights int
    , maximum_nights int
    , minimum_minimum_nights int
    , maximum_minimum_nights int
    , minimum_maximum_nights int
    , maximum_maximum_nights int
    , minimum_nights_avg_ntm numeric
    , maximum_nights_avg_ntm numeric
    , calendar_updated text
    , has_availability char(1)
    , availability_30 int
    , availability_60 int
    , availability_90 int
    , availability_365 int
    , calendar_last_scraped date
    , number_of_reviews int
    , number_of_reviews_ltm int
    , number_of_reviews_l30d int
    , first_review date
    , last_review date
    , review_scores_rating numeric
    , review_scores_accuracy numeric
    , review_scores_cleanliness numeric
    , review_scores_checkin numeric
    , review_scores_communication numeric
    , review_scores_location numeric
    , review_scores_value numeric
    , license text
    , instant_bookable char(1)
    , calculated_host_listings_count int
    , calculated_host_listings_count_entire_homes int
    , calculated_host_listings_count_private_rooms int
    , calculated_host_listings_count_shared_rooms int
    , reviews_per_month numeric
);

-- RAW REVIEWS TABLE
DROP TABLE IF EXISTS raw.reviews CASCADE;
CREATE TABLE raw.reviews (
    listings_id bigint
    , id bigint
    , date text
    , reviewer_id bigint
    , reviewer_name text
    , comments text
);
