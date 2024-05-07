--Selecting the 6 months of data we want to join
SELECT * 
FROM CyclisticProject..[202403TripData]

SELECT * 
FROM CyclisticProject..[202402TripData]

SELECT * 
FROM CyclisticProject..[202401TripData]

SELECT * 
FROM CyclisticProject..[202312TripData]

SELECT * 
FROM CyclisticProject..[202311TripData]

SELECT * 
FROM CyclisticProject..[202310TripData]


--Deleting negative ride lengths and ride lengths longer than 24 hours from all tables
DELETE FROM CyclisticProject..[202403TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202403TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440

DELETE FROM CyclisticProject..[202402TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202402TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440

DELETE FROM CyclisticProject..[202401TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202401TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440

DELETE FROM CyclisticProject..[202312TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202312TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440

DELETE FROM CyclisticProject..[202311TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202311TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440

DELETE FROM CyclisticProject..[202310TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) <=0

DELETE FROM CyclisticProject..[202310TripData]
WHERE convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) >1440


--Use UNION ALL to combine all 6 months of data
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual
FROM CyclisticProject..[202403TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual
FROM CyclisticProject..[202402TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual
FROM CyclisticProject..[202401TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual 
FROM CyclisticProject..[202312TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual 
FROM CyclisticProject..[202311TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, cast(end_station_id as nvarchar(255)),start_lat, start_lng, end_lat, end_lng, member_casual
FROM CyclisticProject..[202310TripData]

--Create temp table for the Union Table 
DROP TABLE if exists UnionTable
CREATE TABLE UnionTable
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
member_casual nvarchar(255),
ride_length_minutes int,
day_of_week int,
date_month int
)
INSERT INTO UnionTable
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202403TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202402TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202401TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202312TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202311TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, datediff(minute,started_at,ended_at) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week, DATEPART(mm, started_at) as date_month
FROM CyclisticProject..[202310TripData]

--Query Union Table of 6 months
SELECT * 
FROM CyclisticProject..UnionTable

SELECT
AVG(ride_length_minutes) as mean_ride_length,
MIN(ride_length_minutes) as min_ride_length,
max(ride_length_minutes) max_ride_length
FROM UnionTable
WHERE member_casual='Member'

SELECT COUNT(ride_id) as casual_users, 
AVG(ride_length_minutes) as mean_ride_length,
MIN(ride_length_minutes) as min_ride_length,
max(ride_length_minutes) max_ride_length
FROM UnionTable
WHERE member_casual='Casual'

SELECT AVG(ride_length_minutes) as mean_ride_length
FROM UnionTable
WHERE member_casual='Casual'

--I noticed that there is no decimal points in minutes. Solution is to convert the result of datediff to seconds/60.0 to Decimal
DROP TABLE if exists UnionTable
CREATE TABLE UnionTable
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
member_casual nvarchar(255),
ride_length_minutes decimal(10,2),
day_of_week int,
)
INSERT INTO UnionTable
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202403TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202402TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202401TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202312TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202311TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202310TripData]

--Querying the created table
SELECT day_of_week,
AVG(ride_length_minutes) as mean_ride_length
--MAX(ride_length_minutes) as max_ride_length,
--MIN(ride_length_minutes) as min_ride_length
FROM UnionTable
WHERE member_casual='Member'
GROUP BY day_of_week
ORDER BY 1,2

--AVG ride length for Members
SELECT day_of_week,
AVG(ride_length_minutes) as mean_ride_length_members
--MAX(ride_length_minutes) as max_ride_length
--MIN(ride_length_minutes) as min_ride_length
FROM UnionTable
WHERE member_casual='Member'
GROUP BY day_of_week
ORDER BY 1,2

--MAX ride length for Members
SELECT day_of_week,
--AVG(ride_length_minutes) as mean_ride_length
MAX(ride_length_minutes) as max_ride_length_members
--MIN(ride_length_minutes) as min_ride_length
FROM UnionTable
WHERE member_casual='Member'
GROUP BY day_of_week
ORDER BY 1,2

--MIN ride length for Members
SELECT day_of_week,
--AVG(ride_length_minutes) as mean_ride_length
--MAX(ride_length_minutes) as max_ride_length
MIN(ride_length_minutes) as min_ride_length_members
FROM UnionTable
WHERE member_casual='Member'
GROUP BY day_of_week
ORDER BY 1,2

--AVG ride length for Casuals
SELECT day_of_week,
AVG(ride_length_minutes) as mean_ride_length_casuals
--MAX(ride_length_minutes) as max_ride_length
--MIN(ride_length_minutes) as min_ride_length
FROM UnionTable
WHERE member_casual='Casual'
GROUP BY day_of_week
ORDER BY 1,2

--MAX ride length for Casuals
SELECT day_of_week,
--AVG(ride_length_minutes) as mean_ride_length
MAX(ride_length_minutes) as max_ride_length_casuals
--MIN(ride_length_minutes) as min_ride_length
FROM UnionTable
WHERE member_casual='Casual'
GROUP BY day_of_week
ORDER BY 1,2

--MIN ride length for Members
SELECT day_of_week,
--AVG(ride_length_minutes) as mean_ride_length
--MAX(ride_length_minutes) as max_ride_length
MIN(ride_length_minutes) as min_ride_length_casuals
FROM UnionTable
WHERE member_casual='Casual'
GROUP BY day_of_week
ORDER BY 1,2

--PER MONTH AVG, MIN, MAX for Casuals
CREATE VIEW avg_min_max_casuals as
SELECT datepart(mm, started_at) as date_month, datepart(yy, started_at) as date_year, avg(ride_length_minutes) as avg_ride_length, min(ride_length_minutes) as min_ride_length, 
max(ride_length_minutes) as max_ride_length
FROM UnionTable
WHERE member_casual='casual'
GROUP BY datepart(yy, started_at), datepart(mm, started_at)


--PER MONTH AVG, MIN, MAX for Members
CREATE VIEW avg_min_max_members as
SELECT datepart(mm, started_at) as date_month, datepart(yy, started_at) as date_year, avg(ride_length_minutes) as avg_ride_length, min(ride_length_minutes) as min_ride_length,
max(ride_length_minutes) as max_ride_length
FROM UnionTable
WHERE member_casual='member'
GROUP BY datepart(yy, started_at), datepart(mm, started_at)

--Try out the views if they're working
Select * 
FROM avg_min_max_members
ORDER BY date_year, date_month

SELECT *
FROM avg_min_max_casuals
ORDER BY date_year, date_month