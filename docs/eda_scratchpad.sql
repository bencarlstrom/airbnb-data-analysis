/*
 *  EXPLORATORY DATA ANALYSIS
 *  Scratchpad used for inspecting ranges, null values, etc.
 *  Includes documentation of each data field in the raw data and how to process it
 */

--==========================================================================================================
-- Raw Data
--==========================================================================================================

-- id bigint
-- used as pk in listings table
select count(*) from raw.listings where id is null; -- 0;
select min(id) from raw.listings; -- 35,797
select max(id)  from raw.listings; -- 1,053,802,004,269,490,593 -- that's quadrillion

-- listing_url text
-- delete

-- scrape_id bigint
-- delete

-- last_scraped date
-- delete

-- source text
-- delete

-- name text
-- used in listings table
select count(*) from raw.listings where name is null; -- 0
select count(*) from raw.listings where name like ''; -- 0
select distinct name from raw.listings;

-- description text
-- always empty, delete
select count(*) from raw.listings where description is not null; -- 0
select count(*) from raw.listings where description not like ''; -- 0

-- neighborhood_overview text
-- delete
select distinct neighborhood_overview from raw.listings; -- about 500 filled out

-- picture_url text
-- delete

-- host_id int
-- used in listings table as pk for hosts table
select count(*) from raw.listings where host_id is null; -- 0
select min(host_id) from raw.listings; -- 7,365
select max(host_id) from raw.listings; -- 552,309,308

-- host_url text
-- delete

-- host_name text
-- used in hosts table
select count(*) from raw.listings where host_name is null; -- 2 and these listings have reviews
select count(*) from raw.listings where host_name like ''; -- 0
-- QUESTION: how to treat these two null values? Leave them in

-- host_since date
-- used in hosts table
select count(*) from raw.listings where host_since is null; -- 2
-- QUESTION: how to treat these two null values? Leave them in

-- host_location text
-- delete, almost all say Mexico City or they're null
select count(*) from raw.listings where host_location is null; -- 5,540
select count(*) from raw.listings where host_location like '%M_xico City%'; -- 17,299
select distinct host_location from raw.listings; -- 387

-- host_about text
-- used in hosts table
select count(*) from raw.listings where host_about is null; -- 2
select count(*) from raw.listings where host_about like ''; -- 11,324
-- QUESTION: too many null values for this to be useful? Maybe, but leave them in

-- host_response_time text
-- 3,396 N/A values
-- make this into a reference table due to limited range of responses (DONE)
select count(*) from raw.listings where host_response_time like 'N/A'; -- 3,396 N/A values
select count(*) from raw.listings where host_response_time like ''; -- 0
select count(*) from raw.listings where host_response_time is null; -- 2
select distinct host_response_time from raw.listings;
-- QUESTION: how to handle so many N/A values? Converted them to null

-- host_response_rate text
select count(*) from raw.listings where host_response_rate is null; -- 2
select count(*) from raw.listings where host_response_rate like 'N/A'; -- 3,396
select distinct host_response_rate from raw.listings;

-- host_acceptance_rate text
select count(*) from raw.listings where host_acceptance_rate is null; -- 2
select count(*) from raw.listings where host_acceptance_rate like 'N/A'; -- 2,606
select distinct host_acceptance_rate from raw.listings;

-- host_is_superhost char(1)
select count(*) from raw.listings where host_is_superhost like ''; -- 0
select count(*) from raw.listings where host_is_superhost not in ('t', 'f'); -- 0
select count(*) from raw.listings where host_is_superhost is null; -- 238
-- QUESTION: how to treat null values for a boolean? leave it in

-- host_thumbnail_url text
-- delete

-- host_picture_url text
-- delete

-- host_neighborhood text
-- has empty values and incorrect values (e.g. Bed-Stuy, Stanford)
select distinct host_neighborhood from raw.listings;

-- host_listings_count int
select count(*) from raw.listings where host_listings_count = 0; -- 0
select count(*) from raw.listings where host_listings_count is null; -- 2

-- host_total_listings_count int
select count(*) from raw.listings where host_total_listings_count = 0; -- 0
select count(*) from raw.listings where host_listings_count != host_total_listings_count; -- 13,023
select host_listings_count, host_total_listings_count from raw.listings where host_listings_count != host_total_listings_count;
select count(*) from raw.listings where host_listings_count > host_total_listings_count; -- 0, total always larger value
-- QUESTION: inside airbnb dictionary doesn't clarify what the difference is between host listings count and total count

-- host_verifications text
-- used as fk in hosts table
select count(*) from raw.listings where host_verifications is null; -- 0
select count(*) from raw.listings where host_verifications like ''; -- 0
select distinct host_verifications from raw.listings; -- [] and None
select count(*) from raw.listings where host_verifications like '[]'; -- 24
select count(*) from raw.listings where host_verifications like 'None'; -- 2
-- so there should be 26 with a fk value of 1

-- host_has_profile_pic char(1)
-- use in hosts table
select count(*) from raw.listings where host_has_profile_pic is null; -- 2
select count(*) from raw.listings where host_has_profile_pic not like 't'; -- 427
select count(*) from raw.listings where host_has_profile_pic like 'f'; -- 427
select distinct host_has_profile_pic from raw.listings;

-- host_identity_verified char(1)
-- use in hosts table
select count(*) from raw.listings where host_identity_verified is null; -- 2
select count(*) from raw.listings where host_identity_verified not like 't'; -- 1,166
select count(*) from raw.listings where host_identity_verified like 'f'; -- 1,166
select distinct host_identity_verified from raw.listings;

-- neighborhood text
-- has empty values, delete
select distinct neighborhood from raw.listings;

-- neighborhood_cleansed text
-- convert to fk in listings table
select count(*) from raw.listings where neighborhood_cleansed is null; -- 0
select count(*) from raw.listings where neighborhood_cleansed like ''; -- 0
select distinct neighborhood_cleansed from raw.listings;

-- neighborhood_group_cleansed text
-- empty, delete

-- latitude double precision
-- delete

-- longitude double precision
-- delete

-- property_type text
-- convert to fk (DONE)
select count(*) from raw.listings where property_type is null; -- 0
select count(*) from raw.listings where property_type like ''; -- 0
select count(distinct property_type) from raw.listings; -- 94
select distinct property_type from raw.listings;

-- room_type text
-- convert to fk in listings table (DONE)
select count(*) from raw.listings where room_type is null; -- 0
select count(*) from raw.listings where room_type like ''; -- 0

-- accommodates int
select count(*) from raw.listings where accommodates = 0; -- 0
select count(*) from raw.listings where accommodates > 16; -- 0, max capacity 16
select distinct accommodates from raw.listings;

-- bathrooms int
-- empty, delete

-- bathrooms_text text
-- convert to numeric (DONE)
select count(*)  from raw.listings where bathrooms_text is null; -- 21
select count(*)  from raw.listings where bathrooms_text like ''; -- 0
select distinct bathrooms_text from raw.listings;

-- bedrooms int
-- empty, delete

-- beds int
select count(*)  from raw.listings where bathrooms_text is null; -- 21
select count(*)  from raw.listings where bathrooms_text like ''; -- 0
select count(*) from raw.listings where beds = 0; -- 0
select count(*) from raw.listings where beds > 35; -- 7
-- QUESTION: how are there 7 Airbnbs with more than 35 beds, but no airbnb can accommodate more than 16 guests?

-- amenities text
-- [], delete

-- price text
-- convert to numeric (DONE)
select count(*) from raw.listings where price is null; -- 1,031
select count(*) from raw.listings where price like ''; -- 0

-- minimum_nights int
select count(*) from raw.listings where minimum_nights = 0; -- 0
select count(*) from raw.listings where minimum_nights is null; -- 0
select min(minimum_nights) from raw.listings; -- 1
select max(minimum_nights) from raw.listings; -- 1,125
select distinct count(minimum_nights) from raw.listings where minimum_nights > 365; -- 7

-- maximum_nights int
select count(*) from raw.listings where maximum_nights = 0; -- 0
select count(*) from raw.listings where maximum_nights is null; -- 0
select min(maximum_nights) from raw.listings; -- 1
select max(maximum_nights) from raw.listings; -- 1,825
select distinct count(maximum_nights) from raw.listings where maximum_nights > 365; -- 10,385

-- minimum_minimum_nights int
-- smallest minimum_nights value from next 365 days
select count(*) from raw.listings where minimum_minimum_nights = 0; -- 0
select count(*) from raw.listings where minimum_minimum_nights is null; -- 0

-- maximum_minimum_nights int
-- largest minimum_nights value from next 365 days
select count(*) from raw.listings where maximum_minimum_nights = 0; -- 0
select count(*) from raw.listings where maximum_minimum_nights is null; -- 0

-- minimum_maximum_nights int
-- smallest maximum_nights value from next 365 days
select count(*) from raw.listings where minimum_maximum_nights = 0; -- 0
select count(*) from raw.listings where minimum_maximum_nights is null; -- 0

-- maximum_maximum_nights int
-- largest maximum_nights value from next 365 days
select count(*) from raw.listings where maximum_maximum_nights = 0; -- 0
select count(*) from raw.listings where maximum_maximum_nights is null; -- 0

-- minimum_nights_avg_ntm numeric
-- average minimum_nights value from next 365 days
select max(minimum_nights_avg_ntm) from raw.listings; -- 9,999
select min(minimum_nights_avg_ntm) from raw.listings; -- 1
select count(*) from raw.listings where minimum_nights_avg_ntm is null; -- 0

-- maximum_nights_avg_ntm numeric
-- average minimum_nights value from next 365 days
select max(maximum_nights_avg_ntm) from raw.listings; -- 9,999
select min(maximum_nights_avg_ntm) from raw.listings; -- 1
select count(*) from raw.listings where maximum_nights_avg_ntm is null; -- 0

-- calendar_updated text
-- empty, delete
select distinct calendar_updated from raw.listings;

-- has_availability char(1)
select has_availability from raw.listings; -- null values present
select count(*) from raw.listings where has_availability not in ('t', 'f'); -- 0
select count(*) from raw.listings where has_availability is null; -- 1,031

-- availability_30 int
select count(*) from raw.listings where availability_30 is null; -- 0
select count(*) from raw.listings where availability_30 > 30; -- 0

-- availability_60 int
select count(*) from raw.listings where availability_60 is null; -- 0
select count(*) from raw.listings where availability_60 > 60; -- 0

-- availability_90 int
select count(*) from raw.listings where availability_90 is null; -- 0
select count(*) from raw.listings where availability_90 > 90; -- 0

-- availability_365 int
select count(*) from raw.listings where availability_365 is null; -- 0
select count(*) from raw.listings where availability_365 > 365; -- 0

-- calendar_last_scraped date
-- delete

-- number_of_reviews int
-- number of reviews all time
select count(*) from raw.listings where number_of_reviews is null; -- 0
select max(number_of_reviews) from raw.listings; -- 1,257
select min(number_of_reviews) from raw.listings; -- 0

-- number_of_reviews_ltm int
-- number of reviews in last 12 months
select count(*) from raw.listings where number_of_reviews_ltm is null; -- 0
select count(*) from raw.listings where number_of_reviews_ltm = 0; -- 6,985
select max(number_of_reviews_ltm) from raw.listings; -- 474
select min(number_of_reviews_ltm) from raw.listings; -- 0

-- number_of_reviews_l30d int
-- number of reviews in last 30 days
select count(*) from raw.listings where number_of_reviews_l30d is null; -- 0
select max(number_of_reviews_l30d) from raw.listings; -- 60
select min(number_of_reviews_l30d) from raw.listings; -- 0
-- QUESTION: does 60 reviews in last 30 days make sense? Yes, multiple guests sharing place each leaving a review

-- first_review date
select count(*) from raw.listings where first_review is null; -- 3,798
-- QUESTION: does this mean 3,798 have never had a guest or never had a review?

-- last_review date
select count(*) from raw.listings where last_review is null; -- 3,798
select listing_url from raw.listings where last_review is null;

-- review_scores_rating numeric
select count(*) from raw.listings where review_scores_rating is null; -- 3,793
select count(*) from raw.listings where review_scores_rating = 0; -- 0
-- QUESTION: replace null values with zero to account for listings with 0 reviews?
-- null number almost matches number of un-reviewed listings exactly, so leave as null
-- small discrepancies probably due to guest not rating specific metric

-- review_scores_accuracy numeric
select count(*) from raw.listings where review_scores_accuracy is null; -- 3,796
select count(*) from raw.listings where review_scores_accuracy = 0; -- 0

-- review_scores_cleanliness numeric
select count(*) from raw.listings where review_scores_cleanliness is null; -- 3,797
select count(*) from raw.listings where review_scores_cleanliness = 0; -- 0

-- review_scores_checkin numeric
select count(*) from raw.listings where review_scores_checkin is null; -- 3,797
select count(*) from raw.listings where review_scores_checkin = 0; -- 0

-- review_scores_communication numeric
select count(*) from raw.listings where review_scores_communication is null; -- 3,796
select count(*) from raw.listings where review_scores_communication = 0; -- 0

-- review_scores_location numeric
select count(*) from raw.listings where review_scores_location is null; -- 3,797
select count(*) from raw.listings where review_scores_location = 0; -- 0

-- review_scores_value numeric
select count(*) from raw.listings where review_scores_value is null; -- 3,799
select count(*) from raw.listings where review_scores_value = 0; -- 0

-- license text
-- empty, delete
select distinct license from raw.listings; -- all null

-- instant_bookable char(1)
select count(*) from raw.listings where listings.instant_bookable is null; -- 0
select count(*) from raw.listings where listings.instant_bookable not in ('t', 'f'); -- 0

-- calculated_host_listings_count int
select count(*) from raw.listings where listings.calculated_host_listings_count is null; -- 0
select count(*) from raw.listings where listings.calculated_host_listings_count = 0; -- 0
select distinct calculated_host_listings_count from raw.listings
order by calculated_host_listings_count; -- max is 266
select distinct host_listings_count from raw.listings
order by host_listings_count; -- max is 2,603
select max(host_total_listings_count) from raw.listings;

-- calculated_host_listings_count_entire_homes int
select count(*) from raw.listings where listings.calculated_host_listings_count_entire_homes is null; -- 0
select count(*) from raw.listings where listings.calculated_host_listings_count_entire_homes = 0; -- 6,975
select distinct calculated_host_listings_count_entire_homes from raw.listings
order by calculated_host_listings_count_entire_homes; -- 266

-- calculated_host_listings_count_private_rooms int
select count(*) from raw.listings where listings.calculated_host_listings_count_private_rooms is null; -- 0
select count(*) from raw.listings where listings.calculated_host_listings_count_private_rooms = 0; -- 15,181
select distinct calculated_host_listings_count_private_rooms from raw.listings
order by calculated_host_listings_count_private_rooms; -- 61

-- calculated_host_listings_count_shared_rooms int
select count(*) from raw.listings where listings.calculated_host_listings_count_shared_rooms is null; -- 0
select count(*) from raw.listings where listings.calculated_host_listings_count_shared_rooms = 0; -- 25,990 this is almost every single host
select distinct calculated_host_listings_count_shared_rooms from raw.listings
order by calculated_host_listings_count_shared_rooms; -- 51

-- reviews_per_month numeric
select count(*) from raw.listings where reviews_per_month is null; -- 3,798
select count(*) from raw.listings where reviews_per_month = 0; -- 0
select distinct reviews_per_month from raw.listings order by reviews_per_month;
-- QUESTION: replace null values with zero to account for listings with 0 reviews?
-- probably not because a rating of 0 is different than no rating at all

select count(*) from raw.reviews where id is null; -- 0
select count(*) from raw.reviews where listings_id is null; -- 0


--==========================================================================================================
-- Staging Data
--==========================================================================================================

select price, name, host_about, host_is_superhost, host_listings_count, neighborhood_cleansed, property_type, room_type,
    bathrooms_text, beds, minimum_nights, number_of_reviews
from staging.listings
where price is not null order by price desc;
-- first row: 1,838,000 pesos for one night in a private room is probably a scam, and the listing has only one review
-- second row: 888,888 pesos for a condo, min stay 1 year, 100+ reviews

-- Check prices for short-term stays
select price, name, host_about, host_is_superhost, host_listings_count, neighborhood_cleansed, property_type, room_type,
    bathrooms_text, beds, minimum_nights, number_of_reviews
from staging.listings
where price is not null
and minimum_nights < 7
order by price desc;
