CREATE DATABASE EmployeeRecords;
use EmployeeRecords;
CREATE TABLE EmployeeData (
    Employee_ID INT,
    Age INT,
    Attrition VARCHAR(10),
    Business_Travel VARCHAR(50),
    Department VARCHAR(100),
    Distance_From_Home INT,
    Education VARCHAR(50),
    Environment_Satisfaction INT,
    Gender VARCHAR(10),
    Salary INT,
    Job_Involvement INT,
    Job_Level INT,
    Job_Role VARCHAR(100),
    Job_Satisfaction INT,
    Marital_Status VARCHAR(20),
    Number_of_Companies_Worked_previously INT,
    Overtime VARCHAR(5),
    Salary_Hike_in_percent INT,
    Total_working_years_experience INT,
    Work_life_balance INT,
    No_of_years_worked_at_current_company INT,
    No_of_years_in_current_role INT,
    Years_since_last_promotion INT
);

SET GLOBAL local_infile = 1;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_Attrition_dataset.csv"
INTO TABLE EmployeeData 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## Overall Attrition Rate
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Attrition_Rate_Percent
FROM EmployeeData;

## Attrition by Department
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Attrition_Rate_Percent
FROM EmployeeData
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;

## Average Salary by Job Role
SELECT 
    Job_Role,
    AVG(Salary) AS Average_Salary
FROM EmployeeData
GROUP BY Job_Role
ORDER BY Average_Salary DESC;
 
## Average Work-Life Balance Score by Department
SELECT 
    Department,
    ROUND(AVG(Work_life_balance), 2) AS Avg_Work_Life_Balance
FROM EmployeeData
GROUP BY Department
ORDER BY Avg_Work_Life_Balance DESC;

## Number of Employees by Education Level and Gender
SELECT 
    Education,
    Gender,
    COUNT(*) AS Employee_Count
FROM EmployeeData
GROUP BY Education, Gender
ORDER BY Education, Gender;

## Overtime vs Attrition
SELECT 
    Overtime,
    Attrition,
    COUNT(*) AS Count
FROM EmployeeData
GROUP BY Overtime, Attrition
ORDER BY Overtime, Attrition;

## Top 5 Job Roles with Highest Attrition
SELECT 
    Job_Role,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Attrition_Rate
FROM EmployeeData
GROUP BY Job_Role
ORDER BY Attrition_Rate DESC
LIMIT 5;

## Average Years Since Last Promotion by Attrition
SELECT 
    Attrition,
    ROUND(AVG(Years_since_last_promotion), 2) AS Avg_Years_Since_Promotion
FROM EmployeeData
GROUP BY Attrition;

##  Salary Hike and Attrition
SELECT 
    Attrition,
    ROUND(AVG(Salary_Hike_in_percent), 2) AS Avg_Salary_Hike
FROM EmployeeData
GROUP BY Attrition;

## Correlation Analysis Starter: High Salary, Overtime, and Attrition
SELECT 
    CASE 
        WHEN Salary > (SELECT AVG(Salary) FROM EmployeeData) THEN 'High Salary'
        ELSE 'Low Salary'
    END AS Salary_Level,
    Overtime,
    Attrition,
    COUNT(*) AS Count
FROM EmployeeData
GROUP BY Salary_Level, Overtime, Attrition
ORDER BY Salary_Level, Overtime, Attrition;
