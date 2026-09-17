-- ==========================================================
-- EXPLORATORY DATA PROFILING & QUALITY CHECKS (DuckDB / SQL)
-- ==========================================================

-- 1. Inspect Table Schema & Data Types
DESCRIBE raw_usage;

-- 2. Data Volume, Unique Entities & Boundary Sanity Checks
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT session_id) AS unique_sessions,
    COUNT(DISTINCT app_name) AS unique_apps,
    MIN(session_start_time) AS min_session_start,
    MAX(session_start_time) AS max_session_start
FROM raw_usage;

-- 3. Data Quality & Integrity Checks (Nulls and Anomalies)
SELECT
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_users,
    COUNT(*) FILTER (WHERE session_id IS NULL) AS null_sessions,
    COUNT(*) FILTER (WHERE session_start_time IS NULL) AS null_start_times,
    COUNT(*) FILTER (WHERE duration_min < 0) AS negative_duration_count
FROM raw_usage;

-- 4. Check Categorical Cardinality & Flag Values
SELECT 
    is_premium_flag,
    COUNT(*) AS record_count
FROM raw_usage
GROUP BY is_premium_flag;

-- 5. Platform Distribution Check
SELECT 
    access_platform,
    COUNT(DISTINCT user_id) AS user_count,
    COUNT(DISTINCT session_id) AS session_count,
    ROUND(AVG(duration_min), 2) AS avg_duration_min
FROM raw_usage
GROUP BY access_platform
ORDER BY session_count DESC;