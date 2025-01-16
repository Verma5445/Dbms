-- Step 1: Create Database
CREATE DATABASE AppointmentDB;

-- Step 2: Switch to the created database
USE AppointmentDB;



-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    department_id INT,
    specialty_id INT,
    joining_date DATE
);

-- Insert into Doctors
INSERT INTO Doctors VALUES 
(1, 'John', 'Smith', 'john.smith@example.com', '1234567890', 1, 1, '2020-01-01'),
(2, 'Jane', 'Doe', 'jane.doe@example.com', '0987654321', 2, 2, '2021-06-15'),
(3, 'Emily', 'Clark', 'emily.clark@example.com', '5551234567', 3, 3, '2019-09-10');





-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    address TEXT
);

-- Insert into Patients
INSERT INTO Patients VALUES 
(1, 'Alice', 'Brown', 'alice.brown@example.com', '7894561230', '1990-05-20', 'Female', '123 Main St'),
(2, 'Bob', 'Johnson', 'bob.johnson@example.com', '6543219870', '1985-07-15', 'Male', '456 Elm St'),
(3, 'Charlie', 'Williams', 'charlie.williams@example.com', '3216549870', '2000-02-28', 'Male', '789 Oak St');




-- Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Insert into Departments
INSERT INTO Departments VALUES 
(1, 'Cardiology'), 
(2, 'Dermatology'), 
(3, 'Pediatrics');





-- Specialties Table
CREATE TABLE Specialties (
    specialty_id INT PRIMARY KEY,
    specialty_name VARCHAR(100)
);

-- Insert into Specialties
INSERT INTO Specialties VALUES 
(1, 'Cardiology'), 
(2, 'Dermatology'), 
(3, 'General Medicine');




-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATETIME,
    reason TEXT,
    status VARCHAR(20),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Insert into Appointments
INSERT INTO Appointments VALUES 
(1, 1, 1, '2023-12-15 10:00:00', 'Routine checkup', 'Completed'),
(2, 1, 2, '2023-12-20 11:00:00', 'Chest pain', 'Scheduled'),
(3, 2, 3, '2023-12-18 15:00:00', 'Skin rash', 'Cancelled');




-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    appointment_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);


-- Example 1: Payment 
INSERT INTO Payments (payment_id, appointment_id, payment_date, payment_amount, payment_method)
VALUES 
(1, 1, '2025-01-05', 200.00, 'Credit Card'),
(2, 2, '2025-01-06', 150.00, 'Cash'),
(3, 3, '2025-01-07', 300.00, 'Insurance');



-- QURIES

-- 1. Total Number of Appointments for Each Doctor
SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;



-- 2. List All Patients Who Have an Appointment with a Specific Doctor (e.g., Dr. John Smith)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date
FROM 
    Patients p
JOIN 
    Appointments a ON p.patient_id = a.patient_id
JOIN 
    Doctors d ON a.doctor_id = d.doctor_id
WHERE 
    CONCAT(d.first_name, ' ', d.last_name) = 'John Smith';
    
    
    
    
    
-- 3. Find the Number of Appointments Scheduled in a Specific Department
SELECT 
    dep.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    Departments dep
JOIN 
    Doctors doc ON dep.department_id = doc.department_id
JOIN 
    Appointments a ON doc.doctor_id = a.doctor_id
WHERE 
    dep.department_name = 'Cardiology' -- Replace 'Cardiology' with your department
GROUP BY 
    dep.department_name;
    
    
    
-- 4. Find the Most Popular Specialty Based on Number of Appointments
SELECT 
    s.specialty_name,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    Specialties s
JOIN 
    Doctors d ON s.specialty_id = d.specialty_id
JOIN 
    Appointments a ON d.doctor_id = a.doctor_id
GROUP BY 
    s.specialty_name
ORDER BY 
    total_appointments DESC
LIMIT 1;




-- 5. Get the Total Payment Amount for All Completed Appointments
SELECT 
    SUM(p.payment_amount) AS total_completed_payments
FROM 
    Payments p
JOIN 
    Appointments a ON p.appointment_id = a.appointment_id
WHERE 
    a.status = 'Completed';
    
    
    
    
-- 6. Find the Number of Patients Seen by Each Doctor
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS total_patients
FROM 
    Doctors d
JOIN 
    Appointments a ON d.doctor_id = a.doctor_id
GROUP BY 
    d.doctor_id, d.first_name, d.last_name;





-- 7. List All Patients Who Have Missed Their Appointments (Status 'Cancelled')
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date
FROM 
    Patients p
JOIN 
    Appointments a ON p.patient_id = a.patient_id
WHERE 
    a.status = 'Cancelled';





-- 8. Find the Total Number of Appointments for Each Status (Scheduled, Completed, Cancelled)
SELECT 
    a.status,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    Appointments a
GROUP BY 
    a.status;




-- 9. Get the Average Payment Amount for Completed Appointments
SELECT 
    AVG(p.payment_amount) AS avg_payment_amount
FROM 
    Payments p
JOIN 
    Appointments a ON p.appointment_id = a.appointment_id
WHERE 
    a.status = 'Completed';





-- 10. Find the Doctor with the Highest Number of Appointments
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    Doctors d
JOIN 
    Appointments a ON d.doctor_id = a.doctor_id
GROUP BY 
    d.doctor_id, d.first_name, d.last_name
ORDER BY 
    total_appointments DESC
LIMIT 1;
