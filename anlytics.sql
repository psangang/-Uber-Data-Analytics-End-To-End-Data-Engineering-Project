---- BigQuery -----

CREATE OR REPLACE TABLE `uber_de_yt.tbl_analytics` AS (
SELECT 
f.trip_id,
f.VendorID,
d.tpep_pickup_datetime,
d.tpep_dropoff_datetime,
p.passenger_count,
t.trip_distance,
r.rate_code_name,
pick.pickup_latitude,
pick.pickup_longitude,
drop.dropoff_latitude,
drop.dropoff_longitude,
pay.payment_type_name,
f.fare_amount,
f.extra,
f.mta_tax,
f.tip_amount,
f.tolls_amount,
f.improvement_surcharge,
f.total_amount
FROM 

`uber_de_yt.fact_table` f
JOIN `uber_de_yt.datetime_dim` d  ON f.datetime_id=d.datetime_id
JOIN `uber_de_yt.passenger_count_dim` p ON p.passenger_count_id=f.passenger_count_id  
JOIN `uber_de_yt.trip_distance_dim` t  ON t.trip_distance_id=f.trip_distance_id  
JOIN `uber_de_yt.rate_code_dim` r ON r.rate_code_id=f.rate_code_id  
JOIN `uber_de_yt.pickup_location_dim` pick ON pick.pickup_location_id=f.pickup_location_id
JOIN `uber_de_yt.drop_location_dim` drop ON drop.drop_location_id=f.drop_location_id
JOIN `uber_de_yt.payment_type_dim` pay ON pay.payment_type_id=f.payment_type_id)


  ---- Postgres Syntax ------

-- Drop table first if you want to replace it
DROP TABLE IF EXISTS uber_de_yt.tbl_analytics;

-- Create table
CREATE TABLE uber_de_yt.tbl_analytics AS
SELECT 
    f.trip_id,
    f.vendorid,
    d.tpep_pickup_datetime,
    d.tpep_dropoff_datetime,
    p.passenger_count,
    t.trip_distance,
    r.rate_code_name,
    pick.pickup_latitude,
    pick.pickup_longitude,
    drop.dropoff_latitude,
    drop.dropoff_longitude,
    pay.payment_type_name,
    f.fare_amount,
    f.extra,
    f.mta_tax,
    f.tip_amount,
    f.tolls_amount,
    f.improvement_surcharge,
    f.total_amount
FROM uber_de_yt.fact_table f
lEFT JOIN uber_de_yt.datetime_dim d ON f.datetime_id = d.datetime_id
lEFT JOIN uber_de_yt.passenger_count_dim p ON p.passenger_count_id = f.passenger_count_id
lEFT JOIN uber_de_yt.trip_distance_dim t ON t.trip_distance_id = f.trip_distance_id
lEFT JOIN uber_de_yt.rate_code_dim r ON r.rate_code_id = f.rate_code_id
lEFT JOIN uber_de_yt.pickup_location_dim pick ON pick.pickup_location_id = f.pickup_location_id
lEFT JOIN uber_de_yt.drop_location_dim drop ON drop.drop_location_id = f.drop_location_id
lEFT JOIN uber_de_yt.payment_type_dim pay ON pay.payment_type_id = f.payment_type_id;


--- Find the average fare amount by hour of the day

SELECT 

    EXTRACT(HOUR FROM TO_TIMESTAMP(tpep_dropoff_datetime, 'YYYY-MM-DD"T"HH24:MI:SS')) AS hour_of_the_day, round(avg(fare_amount::numeric),2)
FROM tbl_analytics
group by 1
order by 1;

--- Find total number of trips by passenger count

select passenger_count, count(*)
FROM tbl_analytics
group by 1
order by 1;

--- Find top 10 pickup locations based on number of trips

select 
round(pickup_latitude::numeric, 3) as pick_lat,
round(pickup_longitude::numeric, 3) as pick_long,
count(*) as number_of_trips
FROM tbl_analytics
group by 1,2
order by number_of_trips desc
limit 10;

--- What is the total number of trips recorded in the dataset?

select count(trip_id) as total_trips
FROM tbl_analytics;

--- What is the time range (start and end dates) of the dataset?

select min(tpep_pickup_datetime) as start_time, max(tpep_dropoff_datetime) as end_time
FROM tbl_analytics;

--- What are the average values for distance, total fare, tip, and passenger count?

select round(avg(trip_distance)::numeric,2) as avg_distance, round(avg(fare_amount)::numeric,2) as avg_fare_amt, round(avg(total_amount)::numeric,2) as avg_total_amt, 
round(avg(tip_amount)) as avg_tip, round(avg(passenger_count)) as avg_passenger_count
FROM tbl_analytics;

--- Are there any missing or abnormal values in key metrics like fare, tip, or distance?

SELECT
    COUNT(*) AS total_rows,
    
    -- FARE
    SUM(CASE WHEN fare_amount IS NULL THEN 1 ELSE 0 END) AS missing_fare,
    SUM(CASE WHEN fare_amount = 0 THEN 1 ELSE 0 END) AS zero_fare,
    SUM(CASE WHEN fare_amount < 0 THEN 1 ELSE 0 END) AS negative_fare,
    SUM(CASE WHEN fare_amount > 1000 THEN 1 ELSE 0 END) AS extremely_high_fare,
    
    -- TIP
    SUM(CASE WHEN tip_amount IS NULL THEN 1 ELSE 0 END) AS missing_tip,
    SUM(CASE WHEN tip_amount = 0 THEN 1 ELSE 0 END) AS zero_tip,
    SUM(CASE WHEN tip_amount < 0 THEN 1 ELSE 0 END) AS negative_tip,
    SUM(CASE WHEN tip_amount > 500 THEN 1 ELSE 0 END) AS extremely_high_tip,
    
    -- DISTANCE
    SUM(CASE WHEN trip_distance IS NULL THEN 1 ELSE 0 END) AS missing_distance,
    SUM(CASE WHEN trip_distance = 0 THEN 1 ELSE 0 END) AS zero_distance,
    SUM(CASE WHEN trip_distance < 0 THEN 1 ELSE 0 END) AS negative_distance,
    SUM(CASE WHEN trip_distance > 100 THEN 1 ELSE 0 END) AS extremely_high_distance

FROM tbl_analytics;




# Uber Trips Data Analysis

This repository contains a comprehensive analysis of Uber trips dataset. The analysis explores key metrics such as revenue, trip distance, passenger behavior, fare patterns, and temporal and geographic insights.

---

## 🧭 1. Data Overview

- **Total Trips:** Total number of trips recorded in the dataset.  
- **Time Range:** Start and end dates of the dataset.  
- **Average Metrics:** 
  - Distance
  - Total fare
  - Tip
  - Passenger count  
- **Data Quality Checks:** Identification of missing or abnormal values in key metrics like fare, tip, or distance.

---

## 🚕 2. Revenue & Fare Analysis

- **Total Revenue:** Total revenue generated by Uber trips.  
- **Daily Trends:** Total revenue and average fare per trip over time.  
- **Top Vendor:** Vendor contributing the most to total revenue.  
- **Fare Distribution:** Categorization of fares (low, medium, high-value trips).  
- **Temporal Fare Analysis:** Variation of fare across days of the week and months.

---

## 📍 3. Location Insights

- **Top Pickup Locations:** 10 most frequent pickup points.  
- **Top Drop-off Locations:** 10 most frequent drop-off points.  
- **Frequent Routes:** Common pickup-dropoff pairs.  
- **High Revenue Areas:** Locations generating higher average fares or tips.  
- **Distance by Location:** Variation of trip distance based on pickup and drop-off locations.

---

## ⏰ 4. Time-Based Patterns

- **Busiest Hours:** Peak hours for trips.  
- **Trips by Day:** Days of the week with the most trips.  
- **Revenue by Hour:** Changes in total revenue throughout the day.  
- **Distance & Time Correlation:** Relationship between trip distance and time of day.  
- **Tip Patterns:** Hours when passengers tend to give higher tips.

---

## 👥 5. Passenger Behavior

- **Average Fare by Passenger Count**  
- **Most Common Passenger Count**  
- **Distance & Fare by Passenger Count**  
- **Impact of More Passengers:** Effect on total fare.  
- **Tip Behavior:** Differences in tipping across passenger counts.

---

## 🛣️ 6. Trip Distance & Duration

- **Average Trip Distance**  
- **Trip Distance Categories:** Short (<1 mile), Medium (1–6 miles), Long (>10 miles)  
- **Fare by Distance Range**  
- **Revenue Contribution by Distance Range**  
- **Distance-Fare Outliers:** Long trips with unexpectedly low fares

---

## 💳 7. Payment Insights

- **Common Payment Types**  
- **Revenue by Payment Type**  
- **Tip Behavior by Payment Method**  
- **Payment Method Distribution:** Credit card vs. cash  
- **Payment-Fare Correlation**  

---

## ⚡ 8. Vendor & Rate Code Insights

- **Vendor Performance:** Total revenue and number of trips per vendor  
- **Average Fare & Distance per Vendor**  
- **Rate Code Analysis:** Impact on fare and trip distance  
- **Time-Based Rate Code Trends**  

---

## 💰 9. Tip & Driver Performance

- **Average Tip Percentage**  
- **Tip Variation:** By time of day, day of week, and trip distance  
- **Tips by Vendor or Payment Method**  
- **Zero-Tip Trips:** Proportion of trips with no tips  
- **Trip Length vs. Tip Analysis**

---

## 📊 10. Business KPIs & Trends

- **Key Performance Indicators (KPIs):**
  - Total Revenue
  - Total Trip Count
  - Average Distance
  - Average Fare  
- **Revenue Trends:** Daily, weekly, monthly analysis  
- **Average Fare per Mile**  
- **Peak Revenue Hours & Low-Demand Periods**  
- **Seasonal Patterns:** Trip volume and fare trends

---

## 🌎 11. Advanced Insights (for Tableau/Looker)

- **Trip Density Heatmap:** Visualization of pickup locations  
- **Revenue by Geographic Zone**  
- **Fare Correlation:** Pickup time vs. fare  
- **Top 5% Trips by Revenue Contribution**  
- **Distance vs. Fare Outliers Visualization**

---

## 📂 Repository Structure

