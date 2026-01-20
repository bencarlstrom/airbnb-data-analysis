/*
 * Validate the data loaded into the clean tables
 */

WITH validation_checks AS (
    SELECT
        -- ORPHANED LISTINGS
        (SELECT COUNT(*)
        FROM clean.listings l
        LEFT JOIN clean.hosts h ON l.host_id = h.host_id
        WHERE h.host_id IS NULL) AS orphaned_listings,

        -- ORPHANED REVIEWS
        (SELECT COUNT(*)
        FROM clean.reviews r
        LEFT JOIN clean.listings l ON r.listings_id = l.id
        WHERE l.id IS NULL) AS orphaned_reviews,

        -- ORPHANED AVAILABILITY
        (SELECT COUNT(*)
        FROM clean.availability a
        LEFT JOIN clean.listings l ON a.listing_id = l.id
        WHERE l.id IS NULL) AS orphaned_availability,

        -- ORPHANED REVIEW DATA
        (SELECT COUNT(*)
        FROM clean.review_data rd
        LEFT JOIN clean.listings l ON rd.listing_id = l.id
        WHERE l.id IS NULL) AS orphaned_review_data,

        --================================================
        -- Data Integrity
        --================================================
        (SELECT COUNT(*)
        FROM clean.listings
        WHERE price <= 0) AS negative_prices,

        (SELECT COUNT(*)
        FROM clean.reviews
        WHERE date > CURRENT_DATE) AS future_review_dates

)
SELECT 'No orphaned listings' as check_name,
    CASE
        WHEN orphaned_listings = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'No orphaned reviews' as check_name,
    CASE
        WHEN orphaned_reviews = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'No orphaned availability records' as check_name,
    CASE
        WHEN orphaned_availability = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'No orphaned review data records' as check_name,
    CASE
        WHEN orphaned_review_data = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'No negative prices' as check_name,
    CASE
        WHEN negative_prices = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks

UNION ALL

SELECT 'No future review dates' as check_name,
    CASE
        WHEN future_review_dates = 0 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks;
