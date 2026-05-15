-- Task B1: Each employee with manager's name (SELF JOIN)
SELECT e.EmpName AS Employee, m.EmpName AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.ManagerID = m.EmpID;

-- Task B2: Employees who earn more than their direct manager
SELECT e.EmpName AS Employee, e.Salary AS EmpSalary,
       m.EmpName AS Manager, m.Salary AS MgrSalary
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
WHERE e.Salary > m.Salary;

-- Task B3: Employees whose manager works in a different department
SELECT e.EmpName AS Employee, m.EmpName AS Manager,
       ed.DeptName AS EmpDept, md.DeptName AS MgrDept
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
INNER JOIN Department ed ON e.DeptID = ed.DeptID
INNER JOIN Department md ON m.DeptID = md.DeptID
WHERE ed.DeptName != md.DeptName;

-- Task B4: Every employee with project name and weekly hours (3-table join)
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
LEFT JOIN Project p ON a.ProjectID = p.ProjectID;

-- Task B5: Every assignment with employee name, project name, and project's department (4-table join)
SELECT a.EmpID, e.EmpName, p.ProjectName, d.DeptName, a.HoursPerWeek
FROM Assignment a
INNER JOIN Employee e ON a.EmpID = e.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
LEFT JOIN Department d ON p.DeptID = d.DeptID;

-- Task B6: Names and hours of employees working on Mobile App project
SELECT e.EmpName, a.HoursPerWeek, p.ProjectName
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App';

-- Task B7: Lahore employees with project assignments (include those with no assignments)
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
LEFT JOIN Project p ON a.ProjectID = p.ProjectID
WHERE e.City = 'Lahore';

-- Task B8: Employees working on a project from a department different from their own
SELECT e.EmpName, p.ProjectName, ed.DeptName AS EmpDept, pd.DeptName AS ProjectDept
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
INNER JOIN Department ed ON e.DeptID = ed.DeptID
INNER JOIN Department pd ON p.DeptID = pd.DeptID
WHERE e.DeptID != p.DeptID;

-- Task B9: Each department with projects that started in 2024 (include depts with no such projects)
SELECT d.DeptName, p.ProjectName, p.StartDate
FROM Department d
LEFT JOIN Project p ON d.DeptID = p.DeptID AND YEAR(p.StartDate) = 2024;

-- Task B10: Every employee with total weekly hours across all projects (include zero hours)
SELECT e.EmpName, COALESCE(SUM(a.HoursPerWeek), 0) AS TotalHoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
GROUP BY e.EmpID, e.EmpName;