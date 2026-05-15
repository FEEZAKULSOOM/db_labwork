-- Task B1: Salary between 75,000 and 100,000 inclusive, sorted by salary ascending
SELECT EmpName, Salary
FROM Employee
WHERE Salary BETWEEN 75000 AND 100000
ORDER BY Salary ASC;

-- Task B2: Employees hired between Jan 2020 and Dec 2022
SELECT EmpName, HireDate
FROM Employee
WHERE HireDate BETWEEN '2020-01-01' AND '2022-12-31';

-- Task B3: Salary NOT between 80,000 and 100,000
SELECT EmpName, Salary
FROM Employee
WHERE Salary NOT BETWEEN 80000 AND 100000;

-- Task B4: City is Lahore or Islamabad, sort by city then salary descending
SELECT EmpName, City, Salary
FROM Employee
WHERE City IN ('Lahore', 'Islamabad')
ORDER BY City ASC, Salary DESC;

-- Task B5: Employees NOT in Engineering, Sales, or HR departments
SELECT EmpName, DeptName
FROM Employee
WHERE DeptName NOT IN ('Engineering', 'Sales', 'HR');

-- Task B6: Names starting with 'M'
SELECT EmpName
FROM Employee
WHERE EmpName LIKE 'M%';

-- Task B7: Names containing letter 'a' anywhere
SELECT EmpName
FROM Employee
WHERE EmpName LIKE '%a%';

-- Task B8: Names ending with 'an'
SELECT EmpName
FROM Employee
WHERE EmpName LIKE '%an';

-- Task B9: Job title contains 'Engineer' but not in Engineering department
SELECT EmpName, JobTitle, DeptName
FROM Employee
WHERE JobTitle LIKE '%Engineer%' AND DeptName != 'Engineering';

-- Task B10: Employees without a recorded city
SELECT EmpName, City
FROM Employee
WHERE City IS NULL;

-- Task B11: Employees with a recorded city, sorted alphabetically by city
SELECT EmpName, City
FROM Employee
WHERE City IS NOT NULL
ORDER BY City ASC;

-- Task B12: Top 3 highest paid employees
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 3;

-- Task B13: 5 most recently hired employees
SELECT EmpName, HireDate
FROM Employee
ORDER BY HireDate DESC
LIMIT 5;

-- Task B14: Bottom 3 salaries (lowest first)
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary ASC
LIMIT 3;

-- Task B15: Sort by department ascending, then by hire date ascending
SELECT EmpName, DeptName, HireDate
FROM Employee
ORDER BY DeptName ASC, HireDate ASC;