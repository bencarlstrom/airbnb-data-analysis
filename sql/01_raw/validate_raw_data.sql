/*
 *  Validate raw data loaded from CSVs
 */

WITH validation_checks AS (
    SELECT 'No listing should have a null ID' AS check_name,
           COUNT(*) AS actual,
           0 AS expected
    FROM raw.listings
    WHERE id IS NULL

    UNION ALL

    SELECT 'No listing should have a null host_id',
           COUNT(*) AS actual,
           0 AS expected
    FROM raw.listings
    WHERE host_id IS NULL

    UNION ALL

    SELECT 'No review should have a null ID',
           COUNT(*) AS actual,
           0 AS expected
    FROM raw.reviews
    WHERE id IS NULL

    UNION ALL

    SELECT 'No review should have a null listings_id',
           COUNT(*) AS actual,
           0 AS expected
    FROM raw.reviews
    WHERE listings_id IS NULL
)
SELECT
    check_name,
    CASE
        WHEN actual = expected THEN 'pass'
        ELSE 'fail'
    END AS status
FROM validation_checks;
