-- Step 1: Create Database
CREATE DATABASE Depart_DB;

-- Step 2: Switch to the created database
USE Depart_DB;




CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    HireDate DATE,
    DepartmentID INT,
    ManagerID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- Insert Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, HireDate, DepartmentID, ManagerID, Salary) VALUES
(101, 'Kanak', 'Verma', 'kanakverma@.com', '123-456-7890', '2020-06-15', 1, NULL, 70000),
(102, 'Prince', 'Verma', 'princeverma@gmail.com', '234-567-8901', '2021-03-10', 2, 101, 80000),
(103, 'Piyush', 'Verma', 'piyushverma@gmail.com', '345-678-9012', '2022-02-01', 3, 102, 75000);




CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

     
 INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID)
VALUES
(1, 'HR', 101),
(2, 'Engineering', 102),
(3, 'Marketing', 103);






CREATE TABLE PerformanceReviews (
       ReviewID INT PRIMARY KEY,
       EmployeeID INT,
	   ReviewDate DATE,
       PerformanceScore VARCHAR(20),
       Comments TEXT,
       FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
       );
       
INSERT INTO PerformanceReviews (ReviewID, EmployeeID, ReviewDate, PerformanceScore, Comments) VALUES
(1, 101, '2023-12-01', 'Good', 'Meets expectations'),
(2, 102, '2023-11-15', 'Excellent', 'Exceeds expectations'),
(3, 103, '2023-10-10', 'Average', 'Needs improvement');





CREATE TABLE Payroll (
PayrollID INT PRIMARY KEY,
EmployeeID INT,
PaymentDate DATE,
Amount DECIMAL(10,2),
PaymentMethod VARCHAR(50),
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);



INSERT INTO Payroll (PayrollID, EmployeeID, PaymentDate, Amount, PaymentMethod) 
VALUES
(1, 101, '2023-12-01', 2500.00, 'Bank Transfer'),
(2, 102, '2023-12-01', 3000.00, 'Check'),
(3, 103, '2023-12-01', 2700.00, 'Bank Transfer');





-- Queries:


-- 1. Retrieve the names and contact details of employees hired after January 1, 2023.
SELECT FirstName, LastName, Email, Phone
FROM Employees
WHERE HireDate > '2023-01-01';




-- 2. Find the total payroll amount paid to each department.
SELECT d.DepartmentName, SUM(p.Amount) AS TotalPayroll
FROM Payroll p
JOIN Employees e ON p.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;




-- 3. List all employees who have not been assigned a manager.
SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL;




-- 4. Retrieve the highest salary in each department along with the employee’s name.
SELECT d.DepartmentName, e.FirstName, e.LastName, MAX(e.Salary) AS HighestSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName, e.FirstName, e.LastName;




-- 5. Find the most recent performance review for each employee.
SELECT e.FirstName, e.LastName, pr.PerformanceScore, pr.ReviewDate
FROM PerformanceReviews pr
JOIN Employees e ON pr.EmployeeID = e.EmployeeID
WHERE pr.ReviewDate = (SELECT MAX(ReviewDate) FROM PerformanceReviews WHERE EmployeeID = pr.EmployeeID);




-- 6. Count the number of employees in each department.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;




-- 7. List all employees who have received a performance score of "Excellent." Identify the most frequently used payment method in payroll.
SELECT e.FirstName, e.LastName
FROM PerformanceReviews pr
JOIN Employees e ON pr.EmployeeID = e.EmployeeID
WHERE pr.PerformanceScore = 'Excellent';

SELECT PaymentMethod, COUNT(PaymentMethod) AS MethodCount
FROM Payroll
GROUP BY PaymentMethod
ORDER BY MethodCount DESC
LIMIT 1;





-- 8. Retrieve the top 5 highest-paid employees along with their departments.
SELECT e.FirstName, e.LastName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.Salary DESC
LIMIT 5;


-- 9. Show details of all employees who report directly to a specific manager (e.g., ManagerID = 101).
SELECT e.FirstName, e.LastName, e.Email, e.Phone, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.ManagerID = 101;
