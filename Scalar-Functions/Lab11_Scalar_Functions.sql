-- ============================================================
-- DATABASE SYSTEMS - LAB 11
-- Scalar SQL Functions - Part B (Numeric and Date/Time Functions) + Assessment
-- Manual Sections 6, 7 and 9
-- ============================================================

-- Run Lab 10 first because it creates and loads scalar_lab.
USE scalar_lab;

-- ============================================================
-- PART B - NUMERIC AND DATE/TIME FUNCTIONS
-- ============================================================

-- Task B1: ROUND + arithmetic - Section 6; applies a 15% discount.
SELECT ProdName, Price, ROUND(Price * 0.85, 2) AS DiscountedPrice
FROM Product;

-- Task B2: ROUND + arithmetic - Section 6; calculates tax and final price.
SELECT ProdName,
       ROUND(Price * 0.17, 2) AS Tax,
       ROUND(Price * 1.17, 2) AS PriceWithTax
FROM Product;

-- Task B3: FLOOR + CEIL - Section 6; rounds price/1000 down and up.
SELECT ProdName, Price,
       FLOOR(Price / 1000) AS FloorVal,
       CEIL(Price / 1000) AS CeilVal
FROM Product;

-- Task B4: ROUND - Section 6; rounds each price to the nearest hundred.
SELECT ProdName, Price, ROUND(Price, -2) AS RoundedToHundred
FROM Product;

-- Task B5: MOD - Section 6; finds products with odd IDs.
SELECT ProdID, ProdName
FROM Product
WHERE MOD(ProdID, 2) = 1;

-- Task B6: YEAR + MONTHNAME + DAYNAME - Section 7; extracts join-date parts.
SELECT CustID, CustName,
       YEAR(JoinDate) AS JoinYear,
       MONTHNAME(JoinDate) AS JoinMonth,
       DAYNAME(JoinDate) AS JoinDay
FROM Customer;

-- Task B7: DATE_FORMAT - Section 7; formats DOB as DD-Month-YYYY.
SELECT CustName, DOB,
       DATE_FORMAT(DOB, '%d-%M-%Y') AS FormattedDOB
FROM Customer;

-- Task B8: TIMESTAMPDIFF - Section 7; calculates current age in years.
SELECT CustName, DOB,
       TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS Age
FROM Customer;

-- Task B9: DATEDIFF + CURDATE - Section 7; calculates days since joining.
SELECT CustName, JoinDate,
       DATEDIFF(CURDATE(), JoinDate) AS DaysSinceJoin
FROM Customer;

-- Task B10: YEAR - Section 7; finds customers who joined in 2023.
SELECT CustID, CustName, JoinDate
FROM Customer
WHERE YEAR(JoinDate) = 2023;

-- Task B11: MONTH - Section 7; finds products launched in Q4.
SELECT ProdID, ProdName, LaunchDate
FROM Product
WHERE MONTH(LaunchDate) IN (10, 11, 12);

-- Task B12: DATE_SUB - Section 7; finds customers from the last 6 months.
SELECT CustID, CustName, JoinDate
FROM Customer
WHERE JoinDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- Task B13: DATEDIFF + CURDATE - Section 7; calculates product age in days.
SELECT ProdName, LaunchDate,
       DATEDIFF(CURDATE(), LaunchDate) AS AgeInDays
FROM Product;

-- Task B14: DATE_ADD - Section 7; adds exactly 90 days to launch dates.
SELECT ProdName, LaunchDate,
       DATE_ADD(LaunchDate, INTERVAL 90 DAY) AS NinetyDaysLater
FROM Product;

-- Task B15: CONCAT + UPPER + TRIM + TIMESTAMPDIFF + DATE_FORMAT.
-- Section 5 + Section 7; combines scalar functions in one summary.
SELECT CONCAT(
           'Hello ', UPPER(TRIM(CustName)),
           ', age ', TIMESTAMPDIFF(YEAR, DOB, CURDATE()),
           ', joined ', DATE_FORMAT(JoinDate, '%b %Y')
       ) AS Summary
FROM Customer;

-- ============================================================
-- ASSESSMENT - EMPLOYEE DATABASE
-- Manual Section 9
-- ============================================================

CREATE DATABASE IF NOT EXISTS emp_lab;
USE emp_lab;

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(60) NOT NULL,
    Email VARCHAR(80),
    Phone VARCHAR(20),
    DOB DATE,
    HireDate DATE,
    Salary DECIMAL(10,2),
    City VARCHAR(30),
    JobTitle VARCHAR(40)
);

-- Assessment sample data
INSERT INTO Employee VALUES
(2001,' ahmad raza','ahmad@firm.com','0300-1112233','1990-04-12','2018-09-01',120000.50,'Lahore','Senior Engineer'),
(2002,'Sara Imran','SARA@FIRM.COM','0301-4445566','1992-11-20','2019-03-15',95000.00,'Karachi','Software Engineer'),
(2003,'BILAL KHAN','bilal@firm.com','0302-7778899','1993-08-05','2020-01-20',85000.75,'Lahore','QA Engineer'),
(2004,'Fatima Ali',NULL,'0303-1234567','1991-02-14','2017-11-10',110000.00,'Islamabad','Manager'),
(2005,'Hira Yousaf','hira@firm.com',NULL,'1995-06-30','2021-04-05',70000.00,NULL,'Accountant'),
(2006,'Zain Abbas ','zain@firm.com','0305-3456789','1994-10-25','2022-08-30',78000.40,'Karachi','Designer'),
(2007,'Mehwish Anwar','mehwish@FIRM.com','0306-4567890','1989-12-09','2016-07-22',125000.00,'Lahore','Director'),
(2008,'Talha Hussain','talha@firm.com','0307-5678901','1996-03-18','2023-01-09',60000.00,'Islamabad','HR Officer'),
(2009,'Areeba Yasin','areeba@firm.com','0308-6789012','1990-07-22','2019-09-12',90000.99,'Lahore','Analyst'),
(2010,'Hassan Ahmed','hassan@firm.com','0309-7890123','1997-01-30','2024-02-18',65000.00,'Karachi','Junior Developer');

-- Q1: TRIM + UPPER - Section 5; cleans and uppercases names.
SELECT EmpID, FullName AS OriginalName,
       UPPER(TRIM(FullName)) AS CleanedName
FROM Employee;

-- Q2: LOCATE + SUBSTRING - Section 5; extracts email usernames.
SELECT FullName,
       SUBSTRING(Email, 1, LOCATE('@', Email) - 1) AS Username
FROM Employee
WHERE Email IS NOT NULL;

-- Q3: LEFT + CONCAT - Section 5; masks phone numbers.
SELECT FullName, Phone,
       CONCAT(LEFT(Phone, 4), 'XXX-XXXX') AS MaskedPhone
FROM Employee
WHERE Phone IS NOT NULL;

-- Q4: TRIM + LOWER + REPLACE + CONCAT - Section 5; generates company emails.
SELECT FullName,
       CONCAT(LOWER(REPLACE(TRIM(FullName), ' ', '.')), '@company.com') AS GeneratedEmail
FROM Employee;

-- Q5: ROUND + arithmetic - Section 6; applies a 12.5% pay raise.
SELECT FullName, Salary,
       ROUND(Salary * 1.125, 2) AS NewSalary
FROM Employee;

-- Q6: FLOOR + arithmetic - Section 6; rounds salary down to the nearest thousand.
SELECT FullName, Salary,
       FLOOR(Salary / 1000) * 1000 AS RoundedSalary
FROM Employee;

-- Q7: TIMESTAMPDIFF - Section 7; calculates age and years of service.
SELECT FullName,
       TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS AgeYears,
       TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS YearsOfService
FROM Employee;

-- Q8: DATE_FORMAT - Section 7; formats hire dates as DD-Mon-YYYY.
SELECT FullName,
       DATE_FORMAT(HireDate, '%d-%b-%Y') AS FormattedHireDate
FROM Employee;

-- Q9: YEAR - Section 7; finds employees hired in 2019 or later.
SELECT EmpID, FullName, HireDate
FROM Employee
WHERE YEAR(HireDate) >= 2019;

-- Q10: Combined scalar functions - Sections 5 and 7; builds one profile.
SELECT CONCAT(
           UPPER(TRIM(FullName)),
           ' | ', COALESCE(City, 'N/A'),
           ' | ', JobTitle,
           ' | Joined: ', DATE_FORMAT(HireDate, '%d-%b-%Y'),
           ' | Age: ', TIMESTAMPDIFF(YEAR, DOB, CURDATE())
       ) AS Profile
FROM Employee;

-- End of Lab 11
