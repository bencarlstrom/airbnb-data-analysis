/*
 * Validate the transformations on the data loaded into staging from the raw schema
 *
 * host_response_rate: text --> int
 * host_acceptance_rate: text --> int
 * host_is_superhost: char(1) --> boolean
 * host_has_profile_pic: char(1) --> boolean
 * host_identity_verified: char(1) --> boolean
 * bathroom_count: numeric
 * price: text --> numeric
 * has_availability: char(1) --> boolean
 * instant_bookable: char(1) --> boolean
 *
 */

WITH validation_checks AS (
    SELECT
        -- HOST_RESPONSE_RATE
        COUNT(*) FILTER (
            WHERE raw.host_response_rate ~ '[0-9]'
              AND stg.host_response_rate IS NULL
        ) AS hrr_conversion_failures,

        COUNT(*) FILTER (
            WHERE stg.host_response_rate IS NOT NULL
              AND raw.host_response_rate ~ '[0-9]'
              AND stg.host_response_rate != CAST(REGEXP_REPLACE(raw.host_response_rate, '[^0-9]', '', 'g') AS int)
        ) AS hrr_value_mismatches,

        -- HOST_ACCEPTANCE_RATE
        COUNT(*) FILTER (
            WHERE raw.host_acceptance_rate ~ '[0-9]'
              AND stg.host_acceptance_rate IS NULL
        ) AS har_conversion_failures,

        COUNT(*) FILTER (
            WHERE stg.host_acceptance_rate IS NOT NULL
              AND raw.host_acceptance_rate ~ '[0-9]'
              AND stg.host_acceptance_rate != CAST(REGEXP_REPLACE(raw.host_acceptance_rate, '[^0-9]', '', 'g') AS int)
        ) AS har_value_mismatches,

        -- HOST_IS_SUPERHOST
        COUNT(*) FILTER (
            WHERE raw.host_is_superhost IN ('t', 'f')
              AND stg.host_is_superhost IS NULL
        ) AS superhost_conversion_failures,

        COUNT(*) FILTER (
            WHERE (raw.host_is_superhost = 't' AND stg.host_is_superhost IS NOT TRUE)
               OR (raw.host_is_superhost = 'f' AND stg.host_is_superhost IS NOT FALSE)
        ) AS superhost_value_mismatches,

        -- HOST_HAS_PROFILE_PIC
        COUNT(*) FILTER (
            WHERE raw.host_has_profile_pic IN ('t', 'f')
              AND stg.host_has_profile_pic IS NULL
        ) AS hhpp_conversion_failures,

        COUNT(*) FILTER (
            WHERE (raw.host_has_profile_pic = 't' AND stg.host_has_profile_pic IS NOT TRUE)
               OR (raw.host_has_profile_pic = 'f' AND stg.host_has_profile_pic IS NOT FALSE)
        ) AS hhpp_value_mismatches,

        -- HOST_HAS_IDENTITY_VERIFIED
        COUNT(*) FILTER (
            WHERE raw.host_identity_verified IN ('t', 'f')
              AND stg.host_identity_verified IS NULL
        ) AS identity_conversion_failures,

        COUNT(*) FILTER (
            WHERE (raw.host_identity_verified = 't' AND stg.host_identity_verified IS NOT TRUE)
               OR (raw.host_identity_verified = 'f' AND stg.host_identity_verified IS NOT FALSE)
        ) AS identity_value_mismatches,

        -- HAS_AVAILABILITY
        COUNT(*) FILTER (
            WHERE raw.has_availability IN ('t', 'f')
              AND stg.has_availability IS NULL
        ) AS availability_conversion_failures,

        COUNT(*) FILTER (
            WHERE (raw.has_availability = 't' AND stg.has_availability IS NOT TRUE)
               OR (raw.has_availability = 'f' AND stg.has_availability IS NOT FALSE)
        ) AS availability_value_mismatches,

        -- INSTANT_BOOKABLE
        COUNT(*) FILTER (
            WHERE raw.instant_bookable IN ('t', 'f')
              AND stg.instant_bookable IS NULL
        ) AS bookable_conversion_failures,

        COUNT(*) FILTER (
            WHERE (raw.instant_bookable = 't' AND stg.instant_bookable IS NOT TRUE)
               OR (raw.instant_bookable = 'f' AND stg.instant_bookable IS NOT FALSE)
        ) AS bookable_value_mismatches,

        -- BATHROOMS_COUNT
        COUNT(*) FILTER (
            WHERE raw.bathrooms_text IS NOT NULL
              AND stg.bathrooms_count IS NULL
        ) AS bathrooms_conversion_failures,

        COUNT(*) FILTER (WHERE stg.bathrooms_count < 0) AS bathrooms_count_negative,

        COUNT(*) FILTER (WHERE stg.bathrooms_count > 50) AS bathrooms_count_out_of_bounds,

        -- PRICE
        COUNT(*) FILTER (
            WHERE raw.price IS NOT NULL
              AND raw.price != ''
              AND stg.price IS NULL
        ) AS price_conversion_failures,

        COUNT(*) FILTER (
            WHERE stg.price IS NOT NULL
              AND stg.price != CAST(
                  REGEXP_REPLACE(raw.price, '[^0-9.]', '', 'g')
              AS numeric)
        ) AS price_value_mismatches,

        COUNT(*) FILTER (WHERE stg.price < 0) AS price_out_of_bounds

    FROM raw.listings raw
    LEFT JOIN staging.listings stg ON raw.id = stg.id
)
SELECT
    'host_response_rate' AS check_name,
    CASE
        WHEN hrr_conversion_failures = 0 AND hrr_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'host_acceptance_rate' AS check_name,
    CASE
        WHEN har_conversion_failures = 0 AND har_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'host_is_superhost' AS check_name,
    CASE
        WHEN superhost_conversion_failures = 0 AND superhost_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'host_has_profile_pic' AS check_name,
    CASE
        WHEN hhpp_conversion_failures = 0 AND hhpp_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'host_has_identity_verified' AS check_name,
    CASE
        WHEN identity_conversion_failures = 0 AND identity_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'has_availability' AS check_name,
    CASE
        WHEN availability_conversion_failures = 0 AND availability_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'instant_bookable' AS check_name,
    CASE
        WHEN bookable_conversion_failures = 0 AND bookable_value_mismatches = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT
    'bathrooms_count' AS check_name,
    CASE
        WHEN bathrooms_conversion_failures = 0 AND bathrooms_count_out_of_bounds = 0 AND bathrooms_count_out_of_bounds = 0 THEN 'pass'
        WHEN bathrooms_count_out_of_bounds > 0 THEN 'warn'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'price_integrity' AS check_name,
    CASE
        WHEN price_conversion_failures = 0 AND price_value_mismatches = 0 AND price_out_of_bounds = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks;
