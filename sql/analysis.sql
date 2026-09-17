-- ==========================================================
-- BUSINESS & PRODUCT ANALYTICS QUERIES (DuckDB / BigQuery)
-- ==========================================================

-- 1. App Stability & Crash Analysis Matrix
-- Calculates session crash volume and crash rates per application
SELECT 
    app_name,
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(DISTINCT session_id) FILTER (
        WHERE has_crash_ended_flag IN ('Y', 'true', '1') OR crash_time IS NOT NULL
    ) AS crashed_sessions,
    ROUND(
        100.0 * COUNT(DISTINCT session_id) FILTER (
            WHERE has_crash_ended_flag IN ('Y', 'true', '1') OR crash_time IS NOT NULL
        ) / COUNT(DISTINCT session_id), 
        2
    ) AS crash_rate_pct
FROM raw_usage
GROUP BY app_name
ORDER BY crash_rate_pct DESC;

-- 2. Premium vs Free User Cohort Comparison
-- Evaluates whether paying users demonstrate higher engagement and session time
SELECT 
    is_premium_flag,
    COUNT(DISTINCT user_id) AS user_count,
    COUNT(DISTINCT session_id) AS session_count,
    ROUND(AVG(duration_min), 2) AS avg_session_duration_min,
    ROUND(SUM(duration_min) / 60.0, 2) AS total_hours_spent
FROM raw_usage
GROUP BY is_premium_flag;

-- 3. Top 3 Apps by Country (Dense Ranking Window Function)
WITH ranked_apps AS (
    SELECT 
        country,
        app_name,
        COUNT(DISTINCT session_id) AS session_count,
        DENSE_RANK() OVER (PARTITION BY country ORDER BY COUNT(DISTINCT session_id) DESC) AS rank
    FROM raw_usage
    GROUP BY country, app_name
)
SELECT 
    country,
    rank,
    app_name,
    session_count
FROM ranked_apps
WHERE rank <= 3
ORDER BY country, rank;

-- 4. User Session Frequency Distribution
-- Identifies power users versus casual app users
WITH user_session_distribution AS (
    SELECT 
        user_id,
        COUNT(DISTINCT session_id) AS user_total_sessions
    FROM raw_usage
    GROUP BY user_id
)
SELECT 
    CASE 
        WHEN user_total_sessions = 1 THEN '1 Session (One-time)'
        WHEN user_total_sessions BETWEEN 2 AND 5 THEN '2-5 Sessions (Casual)'
        WHEN user_total_sessions BETWEEN 6 AND 20 THEN '6-20 Sessions (Regular)'
        ELSE '20+ Sessions (Power User)'
    END AS user_segment,
    COUNT(*) AS total_users,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS user_pct
FROM user_session_distribution
GROUP BY 1
ORDER BY total_users DESC;