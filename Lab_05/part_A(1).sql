-- Task A1: List employees who earn more than 90,000
SELECT EmpID, EmpName, Salary
FROM Employee
WHERE Salary > 90000;

-- Task A2: Show employees with salary less than or equal to 75,000
SELECT EmpName, Salary
FROM Employee
WHERE Salary <= 75000;

-- Task A3: Find employees in Lahore who earn more than 90,000
SELECT EmpName, City, Salary
FROM Employee
WHERE City = 'Lahore' AND Salary > 90000;

-- Task A4: List employees in Karachi or Islamabad
SELECT EmpName, City
FROM Employee
WHERE City = 'Karachi' OR City = 'Islamabad';

-- Task A5: Find female employees not in Engineering department
SELECT EmpName, Gender, DeptName
FROM Employee
WHERE Gender = 'F' AND DeptName != 'Engineering';

-- Task A6: Male employees earning between 70,000 and 90,000 (using AND only)
SELECT EmpName, Gender, Salary
FROM Employee
WHERE Gender = 'M' AND Salary >= 70000 AND Salary <= 90000;

-- Task A7: Employees who are Software Engineers OR earn more than 100,000
SELECT EmpName, JobTitle, Salary
FROM Employee
WHERE JobTitle = 'Software Engineer' OR Salary > 100000;

-- Task A8: Employees not in Marketing and not in Sales
SELECT EmpName, DeptName
FROM Employee
WHERE DeptName != 'Marketing' AND DeptName != 'Sales';