/*
 * This script creates staging tables
 * Listings table structure matches raw data, with one additional column (bathrooms_count) added for type conversion from text to numeric
 */

-- STAGING LISTINGS TABLE
DROP TABLE IF EXISTS staging.listings CASCADE;
CREATE TABLE staging.listings (
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
    , host_response_rate int
    , host_acceptance_rate int
    , host_is_superhost boolean
    , host_thumbnail_url text
    , host_picture_url text
    , host_neighborhood text
    , host_listings_count int
    , host_total_listings_count int
    , host_verifications text
    , host_has_profile_pic boolean
    , host_identity_verified boolean
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
    , bathrooms_count numeric
    , bedrooms int
    , beds int
    , amenities text
    , price numeric
    , minimum_nights int
    , maximum_nights int
    , minimum_minimum_nights int
    , maximum_minimum_nights int
    , minimum_maximum_nights int
    , maximum_maximum_nights int
    , minimum_nights_avg_ntm numeric
    , maximum_nights_avg_ntm numeric
    , calendar_updated text
    , has_availability boolean
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
    , instant_bookable boolean
    , calculated_host_listings_count int
    , calculated_host_listings_count_entire_homes int
    , calculated_host_listings_count_private_rooms int
    , calculated_host_listings_count_shared_rooms int
    , reviews_per_month numeric
);

-- STAGING REVIEWS TABLE
DROP TABLE IF EXISTS staging.reviews CASCADE;
CREATE TABLE staging.reviews (
    listings_id bigint
    , id bigint
    , date text
    , reviewer_id bigint
    , reviewer_name text
    , comments text
);
