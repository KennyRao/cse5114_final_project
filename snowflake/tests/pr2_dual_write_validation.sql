USE ROLE TRAINING_ROLE;
USE WAREHOUSE MONKEY_WH;
USE DATABASE MONKEY_DB;
USE SCHEMA FINAL_PROJECT;

-- =========================================================
-- PR2 acceptance checks: Spark dual-write compatibility
-- =========================================================

-- 1) New base sink should receive rows once Spark streaming runs.
SELECT COUNT(*) AS base_rows
FROM article_company_match_base;

-- 2) Existing table must continue to receive rows.
SELECT COUNT(*) AS article_match_rows
FROM article_company_match;

-- 3) Existing minute mart must continue to receive rows.
SELECT COUNT(*) AS minute_rows
FROM mart_company_sentiment_minute;

-- 4) Freshness checks for all three sinks.
SELECT MAX(loaded_at) AS base_latest_loaded_at
FROM article_company_match_base;

SELECT MAX(loaded_at) AS article_match_latest_loaded_at
FROM article_company_match;

SELECT MAX(loaded_at) AS minute_latest_loaded_at
FROM mart_company_sentiment_minute;

-- 5) Duplicate-pressure visibility for canonical key convention.
SELECT event_id, company_id, COUNT(*) AS dup_count
FROM article_company_match_base
GROUP BY 1, 2
HAVING COUNT(*) > 1
ORDER BY dup_count DESC
LIMIT 20;
