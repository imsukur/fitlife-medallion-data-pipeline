# Health & Fitness Data Pipeline (Medallion Architecture)

## Project Overview

This project is a SQL-based data pipeline built using the Medallion Architecture (Bronze – Silver – Gold) approach.

The dataset used in this project is the "FitLife: Health & Fitness Tracking Dataset" from Kaggle.

The main goal was to transform raw data into structured and analysis-ready tables using MySQL.

---

## Architecture

### Bronze Layer – Raw Data

- Raw CSV data imported into MySQL  
- No transformations applied  
- Acts as the single source of truth  

**File:**  
`bronze_fitlife360.sql`

---

### Silver Layer – Data Cleaning and Modeling

- Converted data types (VARCHAR to INT, DATE, DECIMAL)  
- Applied CAST and STR_TO_DATE  
- Created structured relational tables:
  - participants  
  - daily_activities  
  - weight_history  
  - fitness_progress  
  - health_metrics  

**File:**  
`silver_fitlife360.sql`

---

### Gold Layer – Aggregations and Analysis

Created analytical tables:

- weekly_summary  
- activity_type_analysis  
- health_risk_scores  
- weight_progress  
- fitness_sessions  
- health_trends  

These tables are ready to be used in BI tools such as Power BI.

**File:**  
`gold_fitlife360.sql`

---

## Key Skills Demonstrated

- SQL (CREATE, INSERT, GROUP BY, CASE, CAST)  
- Data cleaning and type conversion  
- Relational data modeling  
- Aggregations and analytical queries  
- Primary key design  
- Medallion Architecture logic  

---

## Next Step

The next step would be automating the pipeline using Python or scheduling tools.
