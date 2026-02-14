-- Gold Layer - Aggregations for Analysis

CREATE DATABASE gold_fitlife360;
USE gold_fitlife360;

-- Weekly summary

CREATE TABLE weekly_summary AS
SELECT 
    participant_id,
    WEEK(activity_date, 3) AS week_number,
    SUM(daily_steps) AS total_weekly_steps,
    SUM(calories_burned) AS total_calories_burned,
    ROUND(AVG(hours_sleep), 1) AS avg_sleep_hours
FROM silver_fitlife360.daily_activities
GROUP BY participant_id, WEEK(activity_date, 3);

ALTER TABLE weekly_summary 
ADD PRIMARY KEY (participant_id, week_number);

/*
SELECT *
FROM weekly_summary;
*/

-- Activity type analysis

CREATE TABLE activity_type_analysis AS
SELECT 
    activity_type,
    ROUND(AVG(calories_burned), 1) AS avg_calories,
    ROUND(AVG(duration_minutes), 1) AS avg_duration,
    COUNT(*) AS total_sessions
FROM silver_fitlife360.daily_activities
GROUP BY activity_type;

ALTER TABLE activity_type_analysis 
ADD PRIMARY KEY (activity_type);

/*
SELECT *
FROM activity_type_analysis;
*/

-- Health risk scores

/*
SELECT *
FROM silver_fitlife360.health_metrics;
*/

CREATE TABLE health_risk_scores AS
SELECT
    participant_id,
    ROUND(AVG(blood_pressure_systolic), 1) AS avg_systolic,
    ROUND(AVG(blood_pressure_diastolic), 1) AS avg_diastolic,
    ROUND(AVG(resting_heart_rate), 1) AS avg_rst_heart,
    CASE
        WHEN AVG(blood_pressure_systolic) > 140 THEN 'High Risk'
        ELSE 'Normal'
    END AS risk_category
FROM silver_fitlife360.health_metrics
GROUP BY participant_id;

ALTER TABLE health_risk_scores 
ADD PRIMARY KEY (participant_id);

/*
SELECT
    risk_category,
    COUNT(*) AS count
FROM health_risk_scores
GROUP BY risk_category;
*/

-- Weight progress

CREATE TABLE weight_progress AS
SELECT
    participant_id,
    MIN(measurement_date) AS start_date,
    MAX(measurement_date) AS end_date,
    ROUND(AVG(weight_kg), 1) AS avg_weight,
    ROUND(MAX(weight_kg) - MIN(weight_kg), 1) AS weight_change,
    ROUND(AVG(calculated_bmi), 1) AS avg_bmi
FROM silver_fitlife360.weight_history
GROUP BY participant_id;

ALTER TABLE weight_progress 
ADD PRIMARY KEY (participant_id);

-- Fitness sessions

CREATE TABLE fitness_sessions AS
SELECT
    participant_id,
    session_date,
    activity_type,
    duration_minutes,
    intensity,
    calories_burned,
    avg_heart_rate
FROM silver_fitlife360.fitness_progress;

ALTER TABLE fitness_sessions
ADD PRIMARY KEY (participant_id, session_date, activity_type);

-- Health trends

CREATE TABLE health_trends AS
SELECT 
    participant_id,
    measurement_date,
    blood_pressure_systolic,
    blood_pressure_diastolic,
    resting_heart_rate
FROM silver_fitlife360.health_metrics;

ALTER TABLE health_trends 
ADD PRIMARY KEY (participant_id, measurement_date);
