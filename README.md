# -Uber-Data-Analytics-End-To-End-Data-Engineering-Project
Uber Data Analytics | End-To-End Data Engineering Project

# Data Engineering Project

## Project Overview
This project implements a scalable **data engineering pipeline** using **Mage-AI**, **GCP Compute Engine**, **Google BigQuery**, and **Looker/Tableau**. The pipeline extracts data from multiple sources, transforms it into a structured format, loads it into a data warehouse, and enables analysis through BI tools.

## Architecture

The architecture consists of the following components:

1. **Data Sources**
   - Raw data is collected from CSV files, APIs, or existing databases.
   - Examples: transactional databases, logs, external APIs.

2. **GCP Compute Engine**
   - Hosts the Mage-AI ETL pipelines.
   - Provides a scalable environment to run scheduled or on-demand ETL tasks.

3. **Mage-AI ETL**
   - Handles **Extract, Transform, Load (ETL)** workflows.
   - Cleans and transforms raw data.
   - Loads processed data into **Google BigQuery**.

4. **Google BigQuery**
   - Serves as the **central data warehouse**.
   - Optimized for large-scale analytical queries.
   - Stores structured data ready for reporting and visualization.

5. **Looker / Tableau**
   - Connects to BigQuery for **interactive dashboards and reports**.
   - Provides insights to business users.

## Workflow
1. Data is ingested from multiple sources into Mage-AI pipelines.
2. Mage-AI transforms and standardizes the data.
3. Processed data is loaded into BigQuery for storage and analytics.
4. Looker/Tableau queries BigQuery to generate dashboards and reports.

## Technologies Used
- **GCP Compute Engine** – Hosting ETL pipelines.
- **Mage-AI** – ETL orchestration and workflow automation.
- **Google BigQuery** – Data warehouse.
- **Looker / Tableau** – Data visualization.
- **Python packages:** pandas, SQLAlchemy, sshtunnel, dbt, etc.

## Diagram
![Architecture Diagram](https://github.com/psangang/-Uber-Data-Analytics-End-To-End-Data-Engineering-Project/blob/main/Architecture.png)
