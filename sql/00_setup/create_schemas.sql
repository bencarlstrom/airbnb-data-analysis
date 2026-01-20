DROP SCHEMA IF EXISTS raw CASCADE;
DROP SCHEMA IF EXISTS staging CASCADE;
DROP SCHEMA IF EXISTS clean CASCADE;

CREATE SCHEMA raw;
CREATE SCHEMA staging;
CREATE SCHEMA clean;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'staging', 'clean');