SELECT 
    CAST(session_start_time AS DATE) AS event_date,
    app_name,
    country,
    access_platform,
    is_premium_flag,
    APPROX_COUNT_DISTINCT(user_id) AS active_users,
    APPROX_COUNT_DISTINCT(session_id) AS session_count,
    COUNT(*) AS total_events,
    ROUND(SUM(duration_min), 2) AS total_duration_min,
    ROUND(AVG(duration_min), 2) AS avg_session_min,
    APPROX_COUNT_DISTINCT(
        CASE WHEN has_crash_ended_flag IN ('Y', 'true', '1') OR crash_time IS NOT NULL 
             THEN session_id ELSE NULL END
    ) AS crashed_sessions
FROM raw_usage
GROUP BY 
    CAST(session_start_time AS DATE),
    app_name,
    country,
    access_platform,
    is_premium_flag;