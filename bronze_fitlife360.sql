-- Bronze Layer - Raw Data Import

CREATE DATABASE bronze_fitlife360;
USE bronze_fitlife360;

CREATE TABLE ld_fitlife360_raw (
    participant_id VARCHAR(50),
    activity_date VARCHAR(50),
    age VARCHAR(50),
    gender VARCHAR(50),
    height_cm VARCHAR(50),
    weight_kg VARCHAR(50),
    activity_type VARCHAR(50),
    duration_minutes VARCHAR(50),
    intensity VARCHAR(50),
    calories_burned VARCHAR(50),
    avg_heart_rate VARCHAR(50),
    hours_sleep VARCHAR(50),
    stress_level VARCHAR(50),
    daily_steps VARCHAR(50),
    hydration_level VARCHAR(50),
    bmi VARCHAR(50),
    resting_heart_rate VARCHAR(50),
    blood_pressure_systolic VARCHAR(50),
    blood_pressure_diastolic VARCHAR(50),
    health_condition VARCHAR(255),
    smoking_status VARCHAR(50),
    fitness_level VARCHAR(50)
);

TRUNCATE TABLE ld_fitlife360_raw;

-- Note: Update the CSV file path according to your local setup.

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bronze_health_fitness_dataset.csv'
INTO TABLE ld_fitlife360_raw
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Total number of rows
SELECT COUNT(*) FROM ld_fitlife360_raw;

-- Check some rows to see if data loaded correctly
/*
SELECT *
FROM ld_fitlife360_raw
LIMIT 20;
*/

-- Example participant
/*
SELECT participant_id, blood_pressure_diastolic, blood_pressure_systolic
FROM ld_fitlife360_raw
WHERE participant_id = 1;
*/