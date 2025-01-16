-- Step 1: Create Database
CREATE DATABASE UniversityDB;

-- Step 2: Switch to the created database
USE UniversityDB;


-- Create Students Table (with foreign key to Departments)
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Students (student_id, first_name, last_name, email, phone, date_of_birth, enrollment_date, department_id)
VALUES 
(1, 'Rahul', 'Sharma', 'rahul.sharma@example.com', '9876543210', '2000-01-01', '2023-01-01', 1),
(2, 'Priya', 'Singh', 'priya.singh@example.com', '8765432109', '2001-02-15', '2023-02-15', 2),
(3, 'Amit', 'Verma', 'amit.verma@example.com', '7654321098', '2002-03-10', '2023-03-01', 1),
(4, 'Neha', 'Kumar', 'neha.kumar@example.com', '6543210987', '2000-12-25', '2023-01-20', 3),
(5, 'Sahil', 'Gupta', 'sahil.gupta@example.com', '5432109876', '1999-11-05', '2023-02-01', 1),
(6, 'Anjali', 'Mehta', 'anjali.mehta@example.com', '4321098765', '2001-07-15', '2023-03-05', 4),
(7, 'Rohan', 'Desai', 'rohan.desai@example.com', '3210987654', '1998-09-20', '2023-01-15', 2),
(8, 'Sneha', 'Patel', 'sneha.patel@example.com', '2109876543', '2002-04-18', '2023-03-10', 3),
(9, 'Vikram', 'Joshi', 'vikram.joshi@example.com', '1098765432', '2000-05-12', '2023-02-25', 4),
(10, 'Pooja', 'Reddy', 'pooja.reddy@example.com', '1987654321', '2001-08-30', '2023-03-15', 2);





-- Create Courses Table (with foreign keys to Professors and Departments)
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT,
    professor_id INT,
    credits INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

INSERT INTO Courses (course_id, course_name, department_id, professor_id, credits)
VALUES 
(1, 'Database Systems', 1, 1, 4),
(2, 'Thermodynamics', 2, 2, 3),
(3, 'Circuit Design', 3, 3, 3),
(4, 'Operating Systems', 1, 1, 4),
(5, 'Fluid Mechanics', 2, 2, 3),
(6, 'Power Systems', 3, 3, 4),
(7, 'Linear Algebra', 4, 3, 3),
(8, 'Artificial Intelligence', 1, 1, 5);




-- Create Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

INSERT INTO Departments (department_id, department_name)
VALUES 
(1, 'Computer Science'),
(2, 'Mechanical Engineering'),
(3, 'Electrical Engineering'),
(4, 'Mathematics');





-- Create Professors Table
CREATE TABLE Professors (
    professor_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO Professors (professor_id, first_name, last_name, email, phone)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '9876543210'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '8765432109'),
(3, 'Alan', 'Turing', 'alan.turing@example.com', '7654321098'),
(4, 'Raj', 'Kumar', 'raj.kumar@example.com', '6543210987'),
(5, 'Aditi', 'Sharma', 'aditi.sharma@example.com', '5432109876'),
(6, 'Maya', 'Patel', 'maya.patel@example.com', '4321098765');





-- Create Enrollments Table (with foreign keys to Students and Courses)
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);



INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
VALUES 
(1, 1, 1, '2023-01-15', 'A'),
(2, 2, 2, '2023-02-20', 'B'),
(3, 1, 3, '2023-03-10', 'A'),
(4, 2, 1, '2023-01-25', 'B+'),
(5, 3, 2, '2023-02-22', 'A-'),
(6, 4, 4, '2023-03-15', 'B'),
(7, 5, 3, '2023-01-30', 'A'),
(8, 6, 5, '2023-03-05', 'B+'),
(9, 7, 4, '2023-02-18', 'A-'),
(10, 8, 6, '2023-03-10', 'A');




-- 1. Find the Total Number of Students in Each Department
SELECT d.department_name, 
    COUNT(s.student_id) AS total_students
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
GROUP BY d.department_name;



-- 2. List All Courses Taught by a Specific Professor
SELECT c.course_name
FROM Courses c
INNER JOIN Professors p ON c.professor_id = p.professor_id
WHERE p.first_name = 'John' AND p.last_name = 'Doe';




-- 3. Find the Average Grade of Students in Each Course
SELECT c.course_name, AVG(CAST(e.grade AS DECIMAL)) AS average_grade
FROM Enrollments e
INNER JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;




-- 4. List All Students Who Have Not Enrolled in Any Courses
SELECT s.first_name, s.last_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;




-- 5. Find the Number of Courses Offered by Each Department
SELECT d.department_name, COUNT(c.course_id) AS total_courses
FROM Departments d
LEFT JOIN Courses c ON d.department_id = c.department_id
GROUP BY d.department_name;




-- 6. List All Students Who Have Taken a Specific Course
SELECT s.first_name, s.last_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';




-- 7. Find the Most Popular Course Based on Enrollment Numbers
SELECT c.course_name, COUNT(e.enrollment_id) AS total_enrollments
FROM Courses c
INNER JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY total_enrollments DESC
LIMIT 1;




-- 8. Find the Average Number of Credits Per Student in a Department
SELECT d.department_name, AVG(c.credits) AS average_credits
FROM Departments d
INNER JOIN Students s ON d.department_id = s.department_id
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
GROUP BY d.department_name;




-- 9. List All Professors Who Teach in More Than One Department
SELECT p.first_name, p.last_name
FROM Professors p
INNER JOIN Courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.first_name, p.last_name
HAVING COUNT(DISTINCT c.department_id) > 1;




-- 10. Get the Highest and Lowest Grade in a Specific Course
SELECT c.course_name, MAX(e.grade) AS highest_grade, MIN(e.grade) AS lowest_grade
FROM Courses c
INNER JOIN Enrollments e ON c.course_id = e.course_id
WHERE c.course_name = 'Operating Systems'
GROUP BY c.course_name;


