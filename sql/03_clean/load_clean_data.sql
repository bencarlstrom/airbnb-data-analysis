/*
 * Transform staging data into normalized clean schema
 * All transformations happen during INSERT - staging remains immutable
 *
 */

-- HOSTS TABLE
INSERT INTO clean.hosts (
    host_id
    , host_verifications
    , host_response_time
    , host_name
    , host_since
    , host_location
    , host_neighborhood
    , host_about
    , host_response_rate
    , host_acceptance_rate
    , host_is_superhost
    , host_listings_count
    , host_total_listings_count
    , calculated_host_listings_count
    , calculated_host_listings_count_entire_homes
    , calculated_host_listings_count_private_rooms
    , calculated_host_listings_count_shared_rooms
    , host_has_profile_pic
    , host_identity_verified)
SELECT DISTINCT
    host_id
    , CASE
        WHEN host_verifications NOT LIKE '%phone%'
        AND host_verifications NOT LIKE '%email%'
        AND host_verifications NOT LIKE '%work_email%' THEN 1
        WHEN host_verifications LIKE '%phone%'
        AND host_verifications NOT LIKE '%email%'
        AND host_verifications NOT LIKE '%work_email%' THEN 2
        WHEN host_verifications LIKE '%phone%'
        AND host_verifications LIKE '%email%'
        AND host_verifications NOT LIKE '%work_email%' THEN 3
        WHEN host_verifications LIKE '%phone%'
        AND host_verifications LIKE '%email%'
        AND host_verifications LIKE '%work_email%' THEN 4
        WHEN host_verifications NOT LIKE '%phone%'
        AND host_verifications LIKE '%email%'
        AND host_verifications LIKE '%work_email%' THEN 5
        WHEN host_verifications NOT LIKE '%phone%'
        AND host_verifications NOT LIKE '%email%'
        AND host_verifications LIKE '%work_email%' THEN 6
        WHEN host_verifications LIKE '%phone%'
        AND host_verifications NOT LIKE '%email%'
        AND host_verifications LIKE '%work_email%' THEN 7
        WHEN host_verifications NOT LIKE '%phone%'
        AND host_verifications LIKE '%email%'
        AND host_verifications NOT LIKE '%work_email%' THEN 8
        ELSE 1
    END AS host_verifications
    , CASE
        WHEN host_response_time = 'within an hour' THEN 1
        WHEN host_response_time = 'within a few hours' THEN 2
        WHEN host_response_time = 'within a day' THEN 3
        WHEN host_response_time = 'a few days or more' THEN 4
        ELSE 5
    END AS host_response_time
    , host_name
    , host_since
    , host_location
    , host_neighborhood
    , host_about
    , host_response_rate
    , host_acceptance_rate
    , host_is_superhost
    , host_listings_count
    , host_total_listings_count
    , calculated_host_listings_count
    , calculated_host_listings_count_entire_homes
    , calculated_host_listings_count_private_rooms
    , calculated_host_listings_count_shared_rooms
    , host_has_profile_pic
    , host_identity_verified
FROM staging.listings;

-- LISTINGS TABLE
INSERT INTO clean.listings (
    id
    , host_id
    , room_type
    , property_type
    , neighborhood
    , name
    , accommodates
    , bathrooms
    , beds
    , price
    , instant_bookable)
SELECT
    id
    , host_id
    , CASE
        WHEN room_type = 'Entire home/apt' THEN 1
        WHEN room_type = 'Shared room' THEN 2
        WHEN room_type = 'Private room' THEN 3
        WHEN room_type = 'Hotel room' THEN 4
        ELSE 5
    END AS room_type
    , CASE
        WHEN property_type = 'Private room in cabin' THEN 2
        WHEN property_type = 'Private room in tiny home' THEN 3
        WHEN property_type = 'Private room in cottage' THEN 1
        WHEN property_type = 'Private room in hostel' THEN 4
        WHEN property_type = 'Private room in townhouse' THEN 5
        WHEN property_type = 'Entire townhouse' THEN 6
        WHEN property_type = 'Entire vacation home' THEN 7
        WHEN property_type = 'Private room in hut' THEN 8
        WHEN property_type = 'Private room in serviced apartment' THEN 9
        WHEN property_type = 'Hut' THEN 10
        WHEN property_type = 'Private room in floor' THEN 11
        WHEN property_type = 'Private room in guest suite' THEN 12
        WHEN property_type = 'Entire cabin' THEN 13
        WHEN property_type = 'Room in aparthotel' THEN 14
        WHEN property_type = 'Shared room in dorm' THEN 15
        WHEN property_type = 'Private room in loft' THEN 16
        WHEN property_type = 'Shared room in condo' THEN 17
        WHEN property_type = 'Entire home/apt' THEN 18
        WHEN property_type = 'Private room in nature lodge' THEN 19
        WHEN property_type = 'Castle' THEN 20
        WHEN property_type = 'Ranch' THEN 21
        WHEN property_type = 'Shared room in guesthouse' THEN 22
        WHEN property_type = 'Shared room' THEN 23
        WHEN property_type = 'Shared room in serviced apartment' THEN 24
        WHEN property_type = 'Entire rental unit' THEN 25
        WHEN property_type = 'Entire condo' THEN 26
        WHEN property_type = 'Entire in-law' THEN 27
        WHEN property_type = 'Private room in treehouse' THEN 28
        WHEN property_type = 'Private room in dorm' THEN 29
        WHEN property_type = 'Shared room in hostel' THEN 30
        WHEN property_type = 'Tiny home' THEN 31
        WHEN property_type = 'Private room in bed and breakfast' THEN 32
        WHEN property_type = 'Entire chalet' THEN 33
        WHEN property_type = 'Entire place' THEN 34
        WHEN property_type = 'Tipi' THEN 35
        WHEN property_type = 'Farm stay' THEN 36
        WHEN property_type = 'Private room in chalet' THEN 37
        WHEN property_type = 'Shared room in home' THEN 38
        WHEN property_type = 'Private room in resort' THEN 39
        WHEN property_type = 'Room in serviced apartment' THEN 40
        WHEN property_type = 'Entire guest suite' THEN 41
        WHEN property_type = 'Shared room in vacation home' THEN 42
        WHEN property_type = 'Private room in vacation home' THEN 43
        WHEN property_type = 'Room in bed and breakfast' THEN 44
        WHEN property_type = 'Private room in villa' THEN 45
        WHEN property_type = 'Room in hotel' THEN 46
        WHEN property_type = 'Entire hostel' THEN 47
        WHEN property_type = 'Private room in bungalow' THEN 48
        WHEN property_type = 'Shared room in guest suite' THEN 49
        WHEN property_type = 'Shared room in loft' THEN 50
        WHEN property_type = 'Private room' THEN 51
        WHEN property_type = 'Shared room in tent' THEN 52
        WHEN property_type = 'Entire guesthouse' THEN 53
        WHEN property_type = 'Entire home' THEN 54
        WHEN property_type = 'Private room in tent' THEN 55
        WHEN property_type = 'Shared room in cabin' THEN 56
        WHEN property_type = 'Shared room in bed and breakfast' THEN 57
        WHEN property_type = 'Casa particular' THEN 58
        WHEN property_type = 'Entire villa' THEN 59
        WHEN property_type = 'Private room in houseboat' THEN 60
        WHEN property_type = 'Shared room in rental unit' THEN 61
        WHEN property_type = 'Private room in condo' THEN 62
        WHEN property_type = 'Shared room in townhouse' THEN 63
        WHEN property_type = 'Shared room in tiny home' THEN 64
        WHEN property_type = 'Earthen home' THEN 65
        WHEN property_type = 'Entire serviced apartment' THEN 66
        WHEN property_type = 'Tent' THEN 67
        WHEN property_type = 'Entire bungalow' THEN 68
        WHEN property_type = 'Shipping container' THEN 69
        WHEN property_type = 'Entire cottage' THEN 70
        WHEN property_type = 'Private room in farm stay' THEN 71
        WHEN property_type = 'Private room in pension' THEN 72
        WHEN property_type = 'Campsite' THEN 73
        WHEN property_type = 'Room in hostel' THEN 74
        WHEN property_type = 'Entire loft' THEN 75
        WHEN property_type = 'Dome' THEN 76
        WHEN property_type = 'Boat' THEN 77
        WHEN property_type = 'Private room in home' THEN 78
        WHEN property_type = 'Private room in casa particular' THEN 79
        WHEN property_type = 'Private room in guesthouse' THEN 80
        WHEN property_type = 'Private room in barn' THEN 81
        WHEN property_type = 'Private room in lighthouse' THEN 82
        WHEN property_type = 'Private room in castle' THEN 83
        WHEN property_type = 'Private room in tower' THEN 84
        WHEN property_type = 'Shared room in casa particular' THEN 85
        WHEN property_type = 'Private room in earthen home' THEN 86
        WHEN property_type = 'Room in boutique hotel' THEN 87
        WHEN property_type = 'Private room in dome' THEN 88
        WHEN property_type = 'Private room in rental unit' THEN 89
        WHEN property_type = 'Room in casa particular' THEN 90
        WHEN property_type = 'Holiday park' THEN 91
        WHEN property_type = 'Shared room in boutique hotel' THEN 92
        WHEN property_type = 'Private room in shipping container' THEN 93
        WHEN property_type = 'Shared room in hotel' THEN 94
        ELSE 95
    END AS property_type
    , CASE
        WHEN neighborhood_cleansed = 'Benito Juárez' THEN 1
        WHEN neighborhood_cleansed = 'Tlalpan' THEN 2
        WHEN neighborhood_cleansed = 'Tláhuac' THEN 3
        WHEN neighborhood_cleansed = 'Xochimilco' THEN 4
        WHEN neighborhood_cleansed = 'Venustiano Carranza' THEN 5
        WHEN neighborhood_cleansed = 'La Magdalena Contreras' THEN 6
        WHEN neighborhood_cleansed = 'Álvaro Obregón' THEN 7
        WHEN neighborhood_cleansed = 'Coyoacán' THEN 8
        WHEN neighborhood_cleansed = 'Milpa Alta' THEN 9
        WHEN neighborhood_cleansed = 'Miguel Hidalgo' THEN 10
        WHEN neighborhood_cleansed = 'Azcapotzalco' THEN 11
        WHEN neighborhood_cleansed = 'Iztapalapa' THEN 12
        WHEN neighborhood_cleansed = 'Cuajimalpa de Morelos' THEN 13
        WHEN neighborhood_cleansed = 'Iztacalco' THEN 14
        WHEN neighborhood_cleansed = 'Gustavo A. Madero' THEN 15
        WHEN neighborhood_cleansed = 'Cuauhtémoc' THEN 16
        ELSE 17
    END AS neighborhood
    , name
    , accommodates
    , bathrooms
    , beds
    , price
    , instant_bookable
FROM staging.listings;

-- AVAILABILITY TABLE
INSERT INTO clean.availability (
    listing_id
    , has_availability
    , availability_30
    , availability_60
    , availability_90
    , availability_365
    , minimum_nights
    , maximum_nights
    , minimum_minimum_nights
    , maximum_minimum_nights
    , minimum_maximum_nights
    , maximum_maximum_nights
    , minimum_nights_avg_ntm
    , maximum_nights_avg_ntm)
SELECT
    id
    , has_availability
    , availability_30
    , availability_60
    , availability_90
    , availability_365
    , minimum_nights
    , maximum_nights
    , minimum_minimum_nights
    , maximum_minimum_nights
    , minimum_maximum_nights
    , maximum_maximum_nights
    , minimum_nights_avg_ntm
    , maximum_nights_avg_ntm
FROM staging.listings;

-- REVIEW DATA TABLE
INSERT INTO clean.review_data (
    listing_id
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
    , reviews_per_month)
SELECT
    id
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
    , reviews_per_month
FROM staging.listings;

-- REVIEWS TABLE
INSERT INTO clean.reviews(
    id
    , listings_id
    , date
    , reviewer_id
    , reviewer_name
    , comments)
SELECT
    id
    , listings_id
    , CAST(date AS date)
    , reviewer_id
    , reviewer_name
    , comments
FROM staging.reviews;

-- KEYWORDS TABLE
INSERT INTO clean.keywords (
    id
    , listings_id
    , safe
    , clean
    , cheap
    , dangerous
    , dirty
    , expensive
    , good_location
    , bad_location)
SELECT
    id
    , listings_id
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% segur_ %'
          OR ' ' || comments || ' ' ILIKE '% safe %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% limpi_ %'
          OR ' ' || comments || ' ' ILIKE '% clean %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% barat_ %'
          OR ' ' || comments || ' ' ILIKE '% cheap %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% peligros_ %'
          OR ' ' || comments || ' ' ILIKE '% dangerous %'
          OR ' ' || comments || ' ' ILIKE '% sketchy %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% suci_ %'
          OR ' ' || comments || ' ' ILIKE '% dirty %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% costos_ %'
          OR ' ' || comments || ' ' ILIKE '% expensive %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% buena ubicaci_n %'
          OR ' ' || comments || ' ' ILIKE '% good location %' THEN true
        ELSE false
      END
    , CASE
        WHEN ' ' || comments || ' ' ILIKE '% mala ubicaci_n %'
          OR ' ' || comments || ' ' ILIKE '% mala zona %'
          OR ' ' || comments || ' ' ILIKE '% bad location %'
          OR ' ' || comments || ' ' ILIKE '% bad area %' THEN true
        ELSE false
      END
FROM staging.reviews;
