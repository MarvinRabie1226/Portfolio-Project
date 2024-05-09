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
FROM UnionTable

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
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minutes decimal(10,2),
day_of_week int,
)
INSERT INTO UnionTable
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202403TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202402TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202401TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202312TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
DATEPART(dw, started_at) as day_of_week
FROM CyclisticProject..[202311TripData]
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, convert(Decimal(10,2),datediff(second,started_at,ended_at)/60.0) AS ride_length_minutes,
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
DROP VIEW if exists avg_min_max_casuals
CREATE VIEW avg_min_max_casuals as
SELECT datepart(mm, started_at) as date_month, datepart(yy, started_at) as date_year, count(ride_ID) as ride_count, avg(ride_length_minutes) as casual_avg_ride_length, 
min(ride_length_minutes) as casual_min_ride_length, max(ride_length_minutes) as casual_max_ride_length
FROM UnionTable
WHERE member_casual='casual'
GROUP BY datepart(yy, started_at), datepart(mm, started_at)


--PER MONTH AVG, MIN, MAX for Members
DROP VIEW if exists avg_min_max_members
CREATE VIEW avg_min_max_members as
SELECT datepart(mm, started_at) as date_month, datepart(yy, started_at) as date_year, count(ride_ID) as ride_count, avg(ride_length_minutes) as member_avg_ride_length, 
min(ride_length_minutes) as member_min_ride_length, max(ride_length_minutes) as member_max_ride_length
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

--Total Ride counts for members and casuals
SELECT SUM(ride_count) as member_ride_count
FROM avg_min_max_members

SELECT SUM(ride_count) as casual_ride_count
FROM avg_min_max_casuals

--Top starting locations for members
DROP TABLE if exists member_start_station_count
CREATE TABLE member_start_station_count
(
start_station_name nvarchar(255),
member_ride_count int,
)
INSERT INTO member_start_station_count
SELECT start_station_name, COUNT(*) as member_ride_count
FROM UnionTable
WHERE member_casual='member'
and start_station_name !='null'
GROUP BY start_station_name
ORDER BY COUNT(*) DESC

--Top end station for members
DROP TABLE if exists member_end_station_count
CREATE TABLE member_end_station_count
(
end_station_name nvarchar(255),
member_ride_count int,
)
INSERT INTO member_end_station_count
SELECT end_station_name, COUNT(*) as member_ride_count
FROM UnionTable
WHERE member_casual='member'
and end_station_name !='null'
GROUP BY end_station_name
ORDER BY COUNT(*) DESC

--Join the member_ride_count tables
SELECT start_station_name as station_name,
(a.member_ride_count + b.member_ride_count) as total_member_visits
FROM member_start_station_count a
JOIN member_end_station_count b
on a.start_station_name=b.end_station_name
ORDER BY total_member_visits DESC

--Top starting locations for casuals
DROP TABLE if exists start_station_count_casual
CREATE TABLE start_station_count_casual
(
start_station_name nvarchar(255),
casual_ride_count int,
)
INSERT INTO start_station_count_casual
SELECT start_station_name as start_station_name, COUNT(*) as casual_ride_count
FROM UnionTable
WHERE member_casual='casual'
and start_station_name !='null'
GROUP BY start_station_name
ORDER BY COUNT(*) DESC

--Top end station for casuals
DROP TABLE if exists end_station_count_casual
CREATE TABLE end_station_count_casual
(
end_station_name nvarchar(255),
casual_ride_count int,
)
INSERT INTO end_station_count_casual
SELECT TRIM(end_station_name) as end_station_name, COUNT(*) as casual_ride_count
FROM UnionTable
WHERE member_casual='casual'
and end_station_name !='null'
GROUP BY end_station_name
ORDER BY COUNT(*) DESC


--Join casual_ride_count tables
SELECT start_station_name as station_name,
(c.casual_ride_count + d.casual_ride_count) as total_member_visits
FROM start_station_count_casual c
RIGHT JOIN end_station_count_casual d
on c.start_station_name=d.end_station_name
ORDER BY total_member_visits DESC


--Rideable type preferences of Members and Casuals
SELECT rideable_type, COUNT(*) as ride_count
FROM UnionTable
GROUP BY rideable_type
ORDER BY ride_count DESC


--Rideable type preference of Casuals
SELECT rideable_type, COUNT(*) as casual_ride_count
FROM UnionTable
WHERE member_casual='Casual'
GROUP BY rideable_type
ORDER BY casual_ride_count DESC

--Rideable type preference of Members
SELECT rideable_type, COUNT(*) as member_ride_count
FROM UnionTable
WHERE member_casual='member'
GROUP BY rideable_type
ORDER BY member_ride_count DESC
