-- Silver Layer - Data Cleaning and Modeling

CREATE DATABASE silver_fitlife360;
USE silver_fitlife360;

-- Create main table with correct data types

CREATE TABLE silver_all (
participant_id INT,
activity_date DATE,
age INT,
gender ENUM ('M', 'F', 'Other'),
height_cm DECIMAL (5,2),
weight_kg DECIMAL (5,2),
activity_type VARCHAR (50),
duration_minutes INT,
intensity ENUM ('Low', 'Medium', 'High'),
calories_burned DECIMAL (6,2),
avg_heart_rate INT,
hours_sleep DECIMAL (3,1),
stress_level ENUM ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10'),
daily_steps INT,
hydration_level DECIMAL (3,1),
bmi DECIMAL (4,1),
resting_heart_rate DECIMAL (4,1),
blood_pressure_systolic DECIMAL (4,1),
blood_pressure_diastolic DECIMAL (4,1),
health_condition VARCHAR(255),
smoking_status ENUM ('Current', 'Former', 'Never'),
fitness_level DECIMAL (4,2)
);

-- Insert cleaned data from Bronze

INSERT INTO silver_fitlife360.silver_all (
    participant_id,
    activity_date,
    age,
    gender,
    height_cm,
    weight_kg,
    activity_type,
    duration_minutes,
    intensity,
    calories_burned,
    avg_heart_rate,
    hours_sleep,
    stress_level,
    daily_steps,
    hydration_level,
    bmi,
    resting_heart_rate,
    blood_pressure_systolic,
    blood_pressure_diastolic,
    health_condition,
    smoking_status,
    fitness_level
)
SELECT
    CAST(participant_id AS SIGNED),
    STR_TO_DATE(activity_date, '%m/%d/%Y'),
    CAST(age AS SIGNED),
    gender,
    CAST(height_cm AS DECIMAL(5,2)),
    CAST(weight_kg AS DECIMAL(5,2)),
    activity_type,
    CAST(duration_minutes AS SIGNED),
    intensity,
    CAST(calories_burned AS DECIMAL(6,2)),
    CAST(avg_heart_rate AS SIGNED),
    CAST(hours_sleep AS DECIMAL(4,2)),
    CAST(stress_level AS SIGNED),
    CAST(daily_steps AS SIGNED),
    CAST(hydration_level AS DECIMAL(4,2)),
    CAST(bmi AS DECIMAL(5,2)),
    CAST(resting_heart_rate AS DECIMAL(5,2)),
    CAST(blood_pressure_systolic AS DECIMAL(5,2)),
    CAST(blood_pressure_diastolic AS DECIMAL(5,2)),
    health_condition,
    smoking_status,
    CAST(fitness_level AS DECIMAL(5,2))
FROM bronze_fitlife360.ld_fitlife360_raw;

-- Total number of rows
SELECT COUNT(*) FROM silver_all;

-- Preview data
/*
SELECT *
FROM silver_all
LIMIT 100;
*/

-- Example participant
/*
SELECT *
FROM silver_all
WHERE participant_id = 1;
*/

-- --------------------------------------------
-- Create subject-based tables
-- --------------------------------------------

-- Participants (static information)

CREATE TABLE participants AS
SELECT 
    participant_id,
    MAX(age) AS age,
    MAX(gender) AS gender,
    MAX(height_cm) AS height_cm,
    MAX(health_condition) AS health_condition,
    MAX(smoking_status) AS smoking_status
FROM silver_all
GROUP BY participant_id;

ALTER TABLE participants ADD PRIMARY KEY (participant_id);

/*
DESCRIBE participants;
*/

-- Daily activities (changing daily records)

CREATE TABLE daily_activities AS
SELECT 
    participant_id,
    activity_date,
    activity_type,
    duration_minutes,
    intensity,
    calories_burned,
    avg_heart_rate,
    daily_steps,
    hours_sleep,
    stress_level,
    hydration_level
FROM silver_all;

ALTER TABLE daily_activities 
ADD PRIMARY KEY (participant_id, activity_date);

-- Weight history (weight changes over time)

CREATE TABLE weight_history AS
SELECT 
    participant_id,
    activity_date AS measurement_date,
    height_cm,
    weight_kg,
    bmi
FROM silver_all;

ALTER TABLE weight_history
ADD COLUMN calculated_bmi DECIMAL(5,1);

UPDATE weight_history 
SET calculated_bmi = weight_kg / ((height_cm/100) * (height_cm/100));

/*
SELECT *
FROM weight_history;
*/

-- Fitness sessions

CREATE TABLE fitness_progress AS
SELECT 
ROW_NUMBER() OVER (ORDER BY participant_id, activity_date) AS session_id,
participant_id,
activity_date AS session_date,
activity_type,
duration_minutes,
intensity,
calories_burned,
avg_heart_rate
FROM silver_all;

ALTER TABLE fitness_progress 
ADD PRIMARY KEY (session_id);

/*
DESCRIBE fitness_progress;
*/

-- Health metrics

CREATE TABLE health_metrics AS
SELECT
participant_id,
activity_date AS measurement_date,
blood_pressure_systolic,
blood_pressure_diastolic,
resting_heart_rate
FROM silver_all;

ALTER TABLE health_metrics 
ADD PRIMARY KEY (participant_id, measurement_date);

/*
SELECT *
FROM silver_fitlife360.silver_all;
*/
