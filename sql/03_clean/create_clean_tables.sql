/*
 * This script creates tables to hold clean data
 * It also creates and populates lookup tables used in the data analysis
 */

-- HOST RESPONSE TIME LOOKUP
DROP TABLE IF EXISTS clean.host_response_times CASCADE;
CREATE TABLE clean.host_response_times (
    pk int GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , host_response_time text
);

INSERT INTO clean.host_response_times(host_response_time)
VALUES
    ('within an hour')
    , ('within a few hours')
    , ('within a day')
    , ('a few days or more')
    , (NULL);

-- HOST VERIFICATIONS LOOKUP
DROP TABLE IF EXISTS clean.host_verifications CASCADE;
CREATE TABLE clean.host_verifications (
    pk int GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , email boolean
    , phone boolean
    , work_email boolean
);

INSERT INTO clean.host_verifications (email, phone, work_email)
VALUES
    (FALSE, FALSE, FALSE)   -- 1: accounts for None and []
    , (TRUE, FALSE, FALSE)  -- 2
    , (TRUE, TRUE, FALSE)   -- 3
    , (TRUE, TRUE, TRUE)    -- 4
    , (FALSE, TRUE, TRUE)   -- 5
    , (FALSE, FALSE, TRUE)  -- 6
    , (TRUE, FALSE, TRUE)   -- 7
    , (FALSE, TRUE, FALSE); -- 8

-- HOSTS TABLE
DROP TABLE IF EXISTS clean.hosts CASCADE;
CREATE TABLE clean.hosts (
    host_id bigint PRIMARY KEY
    , host_verifications int REFERENCES clean.host_verifications(pk)
    , host_response_time int REFERENCES clean.host_response_times(pk)
    , host_name text
    , host_since date
    , host_location text
    , host_neighborhood text
    , host_about text
    , host_response_rate text
    , host_acceptance_rate text
    , host_is_superhost boolean
    , host_listings_count int
    , host_total_listings_count int
    , calculated_host_listings_count int
    , calculated_host_listings_count_entire_homes int
    , calculated_host_listings_count_private_rooms int
    , calculated_host_listings_count_shared_rooms int
    , host_has_profile_pic boolean
    , host_identity_verified boolean
);

-- PROPERTY TYPES LOOKUP
DROP TABLE IF EXISTS clean.property_types CASCADE;
CREATE TABLE clean.property_types (
    pk int GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , property_type text
);

INSERT INTO clean.property_types (property_type)
VALUES
    ('Private room in cottage')
    , ('Private room in cabin')
    , ('Private room in tiny home')
    , ('Private room in hostel')
    , ('Private room in townhouse')
    , ('Entire townhouse')
    , ('Entire vacation home')
    , ('Private room in hut')
    , ('Private room in serviced apartment')
    , ('Hut')
    , ('Private room in floor')
    , ('Private room in guest suite')
    , ('Entire cabin')
    , ('Room in aparthotel')
    , ('Shared room in dorm')
    , ('Private room in loft')
    , ('Shared room in condo')
    , ('Entire home/apt')
    , ('Private room in nature lodge')
    , ('Castle')
    , ('Ranch')
    , ('Shared room in guesthouse')
    , ('Shared room')
    , ('Shared room in serviced apartment')
    , ('Entire rental unit')
    , ('Entire condo')
    , ('Entire in-law')
    , ('Private room in treehouse')
    , ('Private room in dorm')
    , ('Shared room in hostel')
    , ('Tiny home')
    , ('Private room in bed and breakfast')
    , ('Entire chalet')
    , ('Entire place')
    , ('Tipi')
    , ('Farm stay')
    , ('Private room in chalet')
    , ('Shared room in home')
    , ('Private room in resort')
    , ('Room in serviced apartment')
    , ('Entire guest suite')
    , ('Shared room in vacation home')
    , ('Private room in vacation home')
    , ('Room in bed and breakfast')
    , ('Private room in villa')
    , ('Room in hotel')
    , ('Entire hostel')
    , ('Private room in bungalow')
    , ('Shared room in guest suite')
    , ('Shared room in loft')
    , ('Private room')
    , ('Shared room in tent')
    , ('Entire guesthouse')
    , ('Entire home')
    , ('Private room in tent')
    , ('Shared room in cabin')
    , ('Shared room in bed and breakfast')
    , ('Casa particular')
    , ('Entire villa')
    , ('Private room in houseboat')
    , ('Shared room in rental unit')
    , ('Private room in condo')
    , ('Shared room in townhouse')
    , ('Shared room in tiny home')
    , ('Earthen home')
    , ('Entire serviced apartment')
    , ('Tent')
    , ('Entire bungalow')
    , ('Shipping container')
    , ('Entire cottage')
    , ('Private room in farm stay')
    , ('Private room in pension')
    , ('Campsite')
    , ('Room in hostel')
    , ('Entire loft')
    , ('Dome')
    , ('Boat')
    , ('Private room in home')
    , ('Private room in casa particular')
    , ('Private room in guesthouse')
    , ('Private room in barn')
    , ('Private room in lighthouse')
    , ('Private room in castle')
    , ('Private room in tower')
    , ('Shared room in casa particular')
    , ('Private room in earthen home')
    , ('Room in boutique hotel')
    , ('Private room in dome')
    , ('Private room in rental unit')
    , ('Room in casa particular')
    , ('Holiday park')
    , ('Shared room in boutique hotel')
    , ('Private room in shipping container')
    , ('Shared room in hotel')
    , (NULL);

-- ROOM TYPES LOOKUP
DROP TABLE IF EXISTS clean.room_types CASCADE;
CREATE TABLE clean.room_types (
    pk int GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , room_type text
);

INSERT INTO clean.room_types (room_type)
VALUES
    ('Entire home/apt')
    , ('Shared room')
    , ('Private room')
    , ('Hotel room')
    , (NULL);

-- NEIGHBORHOODS LOOKUP
-- Sources for population and average rent data:
-- https://mexiconewsdaily.com/real-estate/how-do-mexico-city-neighborhoods-rank-by-rental-prices/
-- https://www.globalpropertyguide.com/latin-america/mexico/rental-yields
-- https://www.vivanuncios.com.mx/s-renta-inmuebles/venustiano-carranza-df/v1c1098l10280p1
DROP TABLE IF EXISTS clean.neighborhoods CASCADE;
CREATE TABLE clean.neighborhoods (
    pk int GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , neighborhood text
    , population int
    , avg_rent int
);

INSERT INTO clean.neighborhoods (neighborhood, population, avg_rent)
VALUES
    ('Benito Juárez', 434153, 16439)
     , ('Tlalpan', 699928, 14522)
     , ('Tláhuac', 392313, 4722)
     , ('Xochimilco', 442178, 7870)
     , ('Venustiano Carranza', 443704, 10055)
     , ('La Magdalena Contreras', 247622, null)
     , ('Álvaro Obregón', 759137, 15302)
     , ('Coyoacán', 614447, 15751)
     , ('Milpa Alta', 152685, null)
     , ('Miguel Hidalgo', 414470, 21326)
     , ('Azcapotzalco', 432205, 11847)
     , ('Iztapalapa', 1835486, 6394)
     , ('Cuajimalpa de Morelos', 217686, 15641)
     , ('Iztacalco', 404695, null)
     , ('Gustavo A. Madero', 1173351, 9707)
     , ('Cuauhtémoc', 545884, 22911)
     , (null, null, null);

-- LISTINGS TABLE
DROP TABLE IF EXISTS clean.listings CASCADE;
CREATE TABLE clean.listings (
    id bigint PRIMARY KEY
    , host_id bigint REFERENCES clean.hosts(host_id) NOT NULL
    , room_type int REFERENCES clean.room_types(pk)
    , property_type int REFERENCES clean.property_types(pk)
    , neighborhood int REFERENCES clean.neighborhoods(pk)
    , name text
    , accommodates int
    , bathrooms numeric
    , beds int
    , price numeric
    , instant_bookable boolean
);

-- AVAILABILITY TABLE
DROP TABLE IF EXISTS clean.availability CASCADE;
CREATE TABLE clean.availability (
    listing_id bigint PRIMARY KEY REFERENCES clean.listings(id)
    , has_availability boolean
    , availability_30 int
    , availability_60 int
    , availability_90 int
    , availability_365 int
    , minimum_nights int
    , maximum_nights int
    , minimum_minimum_nights int
    , maximum_minimum_nights int
    , minimum_maximum_nights int
    , maximum_maximum_nights int
    , minimum_nights_avg_ntm numeric
    , maximum_nights_avg_ntm numeric
);

-- REVIEWS DATA TABLE
DROP TABLE IF EXISTS clean.review_data CASCADE;
CREATE TABLE clean.review_data (
    listing_id bigint PRIMARY KEY REFERENCES clean.listings(id)
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
    , reviews_per_month numeric
);

-- REVIEWS TABLE
DROP TABLE IF EXISTS clean.reviews CASCADE;
CREATE TABLE clean.reviews (
    id bigint PRIMARY KEY
    , listings_id bigint REFERENCES clean.listings(id) ON DELETE CASCADE
    , date date
    , reviewer_id bigint
    , reviewer_name text
    , comments text
);

-- KEYWORDS TABLE
DROP TABLE IF EXISTS clean.keywords CASCADE;
CREATE TABLE clean.keywords (
    pk bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    , id bigint REFERENCES clean.reviews(id)
    , listings_id bigint REFERENCES clean.listings(id) ON DELETE CASCADE
    , safe boolean
    , clean boolean
    , cheap boolean
    , dangerous boolean
    , dirty boolean
    , expensive boolean
    , good_location boolean
    , bad_location boolean
);
