--COUNT OF PARTECIPANTS BY DISTINCT IDs FROM EACH DATASET(6)
--1
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM "1_Daily_Activity_CSV" dac; --33
--2
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM  "2_Daily_Sleep_CSV" dsc; --24
--3
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM "3_Hourly_Calories_CSV" hcc; --33
--4
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM "4_Hourly_Intensity_CSV" hic; --33
--5
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM "5_Hourly_Steps_CSV" hsc; --33
--6 
SELECT  COUNT(DISTINCT Id) AS Number_Partecipants
FROM "6_Weight_Log_CSV" wlc; --8

--THE DATASET 6_Weight_Log_CSV DOES NOT INCLUDE ENOUGH DATA, HENCE IT WON'T BE USED. 

--TIMES EACH PARTECIPANTS USED THE FITBIT
SELECT Id, COUNT(DISTINCT ActivityDate) AS DateCount
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id;


--COUNT OF DateCount TO SEE THE FREQUENCY
SELECT DateCount, COUNT(DateCount) AS CountOfCounts 
FROM 
(SELECT Id, COUNT(DISTINCT ActivityDate) AS DateCount
  FROM "1_Daily_Activity_CSV" dac
  GROUP BY Id
) AS subquery
GROUP BY DateCount
ORDER BY CountOfCounts DESC;


--DIVIDING USERS IN 3 CATEGORIES BASED ON THE USAGE
SELECT Id,
COUNT(Id) AS Logged_Times,
CASE
WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Active Usage'
WHEN COUNT(Id) BETWEEN 15 and 24 THEN 'Moderate Usage'
WHEN COUNT(Id) BETWEEN 0 and 14 THEN 'Light Usage'
END Usage_Type
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id;


--HOW MANY OF EACH USAGE TYPE
SELECT Logged_Times, Usage_Type, COUNT(Usage_Type) AS Count_Usage_Type
FROM
(SELECT Id,
COUNT(Id) AS Logged_Times,
CASE
WHEN COUNT(Id) BETWEEN 25 AND 31 THEN "Active Usage"
WHEN COUNT(Id) BETWEEN 15 and 24 THEN "Moderate Usage"
WHEN COUNT(Id) BETWEEN 0 and 14 THEN "Light Usage"
END Usage_Type
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id) 
AS subquery
GROUP BY Usage_Type
ORDER BY COUNT(Usage_Type) DESC;


--EACH USER WITH TOTAL STEPS, DISTANCE AND CALORIES COUNT
SELECT  Id, SUM(TotalSteps) AS Sum_Steps, SUM(TotalDistance) AS Sum_DIstance, SUM(Calories) AS Sum_Calories
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id
ORDER BY SUM(TotalSteps) DESC;


--AVG OF TOTAL STEPS, TOTAL DISTANCE AND CALORIES FOR EACH USER
SELECT Id, AVG(TotalSteps) AS Avg_Steps, AVG(TotalDistance) AS Avg_DIstance, AVG(Calories) AS Avg_Calories
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id
ORDER BY AVG(TotalSteps) DESC; 


--AVG TIME FOR ACTIVITY LEVEL(VERY ACTIVE,FAIRLY ACTIVE LIGHTLY ACTIVE, SEDENTARY) FOR EACH USER PER DAY
SELECT Id,
AVG(VeryActiveMinutes) AS Avg_Very_Active_Minutes,
AVG(FairlyActiveMinutes) AS Avg_Fairly_Active_Minutes,
AVG(LightlyActiveMinutes) AS Avg_Lightly_Active_Minutes,
AVG(SedentaryMinutes) AS Avg_Sedentary_Minutes
From "1_Daily_Activity_CSV" dac
GROUP BY Id;


--DO THE USERS HIT THE CDC RECOMMANDED TIME OF PHYSICAL ACTIVITY EACH WEEK(150 MINS)
SELECT Id, (AVG(VeryActiveMinutes) + AVG(FairlyActiveMinutes))*7 AS Avg_Active_Minutes_Week,
CASE
	WHEN (AVG(VeryActiveMinutes) + AVG(FairlyActiveMinutes))*7 >= 150
	THEN "YES"
	ELSE "NO"
END CDC_Recommendation_Met
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id
ORDER BY Avg_Active_Minutes_Week DESC;


--DO THE USERS HIT THE RECOMMANDED STEPS PER DAY
SELECT Id, AVG(TotalSteps) AS Avg_Steps,
CASE
	WHEN AVG(TotalSteps) < 3000
	THEN "Inactive"
	WHEN AVG(TotalSteps) BETWEEN 3000 AND 4999
	THEN "Low Active User"
	WHEN AVG(TotalSteps) BETWEEN 5000 AND 7999
	THEN "Average Active User"
	WHEN AVG(TotalSteps) BETWEEN 8000 AND 12000
	THEN "Active User"
	ELSE "Very Active User"
END "User_Type"
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id
ORDER BY AVG(TotalSteps) DESC;


--HOW MANY OF EACH USER TYPE
SELECT User_Type, COUNT(User_Type) AS Count_User_Type
FROM
(SELECT Id, AVG(TotalSteps) AS Avg_Steps,
CASE
	WHEN AVG(TotalSteps) < 3000
	THEN "Inactive"
	WHEN AVG(TotalSteps) BETWEEN 3000 AND 4999
	THEN "Low Active User"
	WHEN AVG(TotalSteps) BETWEEN 5000 AND 7999
	THEN "Average Active User"
	WHEN AVG(TotalSteps) BETWEEN 8000 AND 12000
	THEN "Active User"
	ELSE "Very Active User"
END "User_Type"
FROM "1_Daily_Activity_CSV" dac
GROUP BY Id) 
AS subquery
GROUP BY User_Type
ORDER BY COUNT(User_Type) DESC;


--AVERAGE STEPS BY HOURS FOR USERS
SELECT ActivityHour, AVG(StepTotal)
FROM "5_Hourly_Steps_CSV" hsc
GROUP BY ActivityHour
ORDER BY AVG(StepTotal) DESC;

--TOTAL STEPS BY HOURS FOR USERS
SELECT ActivityHour, SUM(StepTotal)
FROM "5_Hourly_Steps_CSV" hsc
GROUP BY ActivityHour 
ORDER BY SUM(StepTotal) DESC


--SLEEP in RELATION TO STEPS AND CALORIES FOR EACH USER
SELECT dsc.Id, AVG(TotalMinutesAsleep) AS Avg_Sleep_Time, AVG(TotalSteps), AVG(Calories)
FROM "2_Daily_Sleep_CSV" dsc
INNER JOIN "1_Daily_Activity_CSV" dac
ON dsc.Id=dac.Id
GROUP BY dsc.Id
ORDER BY Avg_Sleep_Time DESC

--MOST ACTIVE HOUR
SELECT hcc.ActivityHour, AVG(Calories), AVG(StepTotal)
FROM "3_Hourly_Calories_CSV" hcc
INNER JOIN "5_Hourly_Steps_CSV" hsc
ON hcc.Id=hsc.Id
GROUP BY hcc.ActivityHour
