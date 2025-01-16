-- Step 1: Create Database
CREATE DATABASE OlaDB;

-- Step 2: Switch to the created database
USE OlaDB;




-- Creating the Drivers Table
CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(15),
    City VARCHAR(50),
    VehicleType VARCHAR(20),
    Rating DECIMAL(3, 2) CHECK (Rating >= 0 AND Rating <= 5)
);

-- Sample Data for Drivers
INSERT INTO Drivers (DriverID, FirstName, LastName, Phone, City, VehicleType, Rating)
VALUES
 (1, 'John', 'Doe', '1234567890', 'New York', 'Sedan', 4.7),
 (2, 'Jane', 'Smith', '0987654321', 'Los Angeles', 'SUV', 4.3),
 (3, 'Sam', 'Wilson', '5678901234', 'Chicago', 'Hatchback', 4.2),
 (4, 'Emily', 'Johnson', '9876543210', 'San Francisco', 'SUV', 4.8),
 (5, 'Michael', 'Davis', '3456789012', 'Miami', 'Sedan', 3.9),
 (6, 'Olivia', 'Martinez', '2345678901', 'Austin', 'SUV', 4.6);





-- Creating the Riders Table
CREATE TABLE Riders (
    RiderID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(15),
    City VARCHAR(50),
    JoinDate DATE
);

-- Sample Data for Riders
INSERT INTO Riders (RiderID, FirstName, LastName, Phone, City, JoinDate)
VALUES 
(1, 'Alice', 'Brown', '1112223333', 'New York', '2024-08-01'),
(2, 'Bob', 'White', '4445556666', 'Los Angeles', '2024-09-15'),
(3, 'Charlie', 'Taylor', '5556667777', 'Chicago', '2024-10-10'),
(4, 'David', 'Anderson', '7778889999', 'San Francisco', '2024-07-20'),
(5, 'Sophia', 'Thomas', '8889990000', 'Miami', '2024-11-05'),
(6, 'Ethan', 'Jackson', '9990001111', 'Austin', '2024-12-25');





-- Creating the Rides Table
CREATE TABLE Rides (
    RideID INT PRIMARY KEY,
    RiderID INT,
    DriverID INT,
    RideDate DATETIME,
    PickupLocation VARCHAR(100),
    DropLocation VARCHAR(100),
    Distance DECIMAL(5, 2),
    Fare DECIMAL(10, 2),
    RideStatus VARCHAR(20),
    FOREIGN KEY (RiderID) REFERENCES Riders(RiderID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

-- Sample Data for Rides
INSERT INTO Rides (RideID, RiderID, DriverID, RideDate, PickupLocation, DropLocation, Distance, Fare, RideStatus)
VALUES
 (1, 1, 1, '2025-01-01 10:00:00', 'Central Park', 'Times Square', 15, 20.5, 'Completed'),
 (2, 2, 2, '2025-01-05 14:30:00', 'Hollywood Blvd', 'Santa Monica', 25, 35.0, 'Completed'),
 (3, 3, 3, '2025-01-02 09:00:00', 'Navy Pier', 'Magnificent Mile', 10, 15.0, 'Completed'),
 (4, 4, 4, '2025-01-06 16:30:00', 'Golden Gate Bridge', 'Fisherman\'s Wharf', 20, 30.0, 'Completed'),
 (5, 5, 5, '2025-01-07 11:15:00', 'South Beach', 'Wynwood', 12, 18.0, 'Completed'),
 (6, 6, 6, '2025-01-08 13:45:00', 'Zilker Park', 'Downtown Austin', 22, 28.0, 'Completed');





-- Creating the Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    RideID INT,
    PaymentMethod VARCHAR(20),
    Amount DECIMAL(10, 2),
    PaymentDate DATETIME,
    FOREIGN KEY (RideID) REFERENCES Rides(RideID)
);

-- Sample Data for Payments
INSERT INTO Payments (PaymentID, RideID, PaymentMethod, Amount, PaymentDate)
VALUES 
(1, 1, 'Card', 20.5, '2025-01-01 11:00:00'),
(2, 2, 'Cash', 35.0, '2025-01-05 15:00:00'),
(3, 3, 'Wallet', 15.0, '2025-01-02 10:00:00'),
(4, 4, 'Card', 30.0, '2025-01-06 17:00:00'),
(5, 5, 'Cash', 18.0, '2025-01-07 12:00:00'),
(6, 6, 'Wallet', 28.0, '2025-01-08 14:00:00');



# QUERIES

-- 1. Retrieve the names and contact details of all drivers with a rating of 4.5 or higher.
SELECT FirstName, LastName, Phone, City, VehicleType, Rating
FROM Drivers
WHERE Rating >= 4.5;


-- 2. Find the total number of rides completed by each driver.
SELECT D.DriverID, D.FirstName, D.LastName, COUNT(R.RideID) AS TotalRides
FROM Drivers D
LEFT JOIN Rides R ON D.DriverID = R.DriverID
WHERE R.RideStatus = 'Completed'
GROUP BY D.DriverID, D.FirstName, D.LastName;



-- 3. List all riders who have never booked a ride.
SELECT R.FirstName, R.LastName, R.Phone, R.City
FROM Riders R
LEFT JOIN Rides Ri ON R.RiderID = Ri.RiderID
WHERE Ri.RideID IS NULL;


-- 4. Calculate the total earnings of each driver from completed rides.
SELECT D.DriverID, D.FirstName, D.LastName, SUM(P.Amount) AS TotalEarnings
FROM Drivers D
JOIN Rides R ON D.DriverID = R.DriverID
JOIN Payments P ON R.RideID = P.RideID
WHERE R.RideStatus = 'Completed'
GROUP BY D.DriverID, D.FirstName, D.LastName;



-- 5. Retrieve the most recent ride for each rider.
WITH RecentRides AS (
    SELECT R.RiderID, R.RideID, R.RideDate, ROW_NUMBER() OVER (PARTITION BY R.RiderID ORDER BY R.RideDate DESC) AS RowNum
    FROM Rides R
)
SELECT R.FirstName, R.LastName, RR.RideID, RR.RideDate
FROM RecentRides RR
JOIN Riders R ON RR.RiderID = R.RiderID
WHERE RR.RowNum = 1; 



-- 6. Count the number of rides taken in each city.
SELECT City, COUNT(RideID) AS RideCount
FROM Rides R
JOIN Riders Ri ON R.RiderID = Ri.RiderID
GROUP BY City;



-- 7. List all rides where the distance was greater than 20 km.
SELECT RideID, RiderID, DriverID, Distance, Fare
FROM Rides
WHERE Distance > 20;



-- 8. Identify the most preferred payment method.
SELECT PaymentMethod, COUNT(*) AS MethodCount
FROM Payments
GROUP BY PaymentMethod
ORDER BY MethodCount DESC
LIMIT 1;



-- 9. Find the top 3 highest-earning drivers.
SELECT D.DriverID, D.FirstName, D.LastName, SUM(P.Amount) AS TotalEarnings
FROM Drivers D
JOIN Rides R ON D.DriverID = R.DriverID
JOIN Payments P ON R.RideID = P.RideID
WHERE R.RideStatus = 'Completed'
GROUP BY D.DriverID, D.FirstName, D.LastName
ORDER BY TotalEarnings DESC
LIMIT 3;




-- 10. Retrieve details of all cancelled rides along with the rider's and driver's names.
SELECT R.RideID, R.RiderID, Rd.FirstName AS RiderFirstName, Rd.LastName AS RiderLastName,
       D.FirstName AS DriverFirstName, D.LastName AS DriverLastName, R.RideStatus
FROM Rides R
JOIN Riders Rd ON R.RiderID = Rd.RiderID
JOIN Drivers D ON R.DriverID = D.DriverID
WHERE R.RideStatus = 'Cancelled';