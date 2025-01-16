-- Step 1: Create Database
CREATE DATABASE HypotheticalBusinessDB;

-- Step 2: Switch to the created database
USE HypotheticalBusinessDB;



-- Creating the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    join_date DATE
);

-- Inserting sample data into Customers table
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm St', '2024-01-15'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak St', '2023-06-10'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567', '789 Pine St', '2022-03-22'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '444-777-8888', '321 Maple St', '2019-07-14'),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', '222-333-4444', '654 Birch St', '2021-11-01'),
(6, 'Emily', 'Martinez', 'emily.martinez@example.com', '999-888-7777', '987 Cedar St', '2023-01-10'),
(7, 'David', 'Wilson', 'david.wilson@example.com', '666-555-4444', '654 Walnut St', '2022-06-19'),
(8, 'Sophia', 'Moore', 'sophia.moore@example.com', '333-222-1111', '321 Fir St', '2021-09-05');






-- Creating the Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT
);

-- Inserting sample data into Products table
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1200.00, 10),
(2, 'Headphones', 'Electronics', 150.00, 50),
(3, 'T-shirt', 'Clothing', 25.00, 100),
(4, 'Coffee Maker', 'Home Appliances', 85.00, 30),
(5, 'Blender', 'Home Appliances', 80.00, 80),
(6, 'Microwave', 'Home Appliances', 180.00, 30),
(7, 'Table Lamp', 'Furniture', 45.00, 150),
(8, 'Chair', 'Furniture', 60.00, 120);






-- Creating the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Inserting sample data into Orders table
INSERT INTO Orders VALUES
(1, 1, '2025-01-05', 1350.00, 'Shipped'),
(2, 2, '2025-01-02', 200.00, 'Pending'),
(3, 1, '2024-12-25', 75.00, 'Shipped'),
(4, 4, '2023-09-28', 280.00, 'Pending'),
(5, 5, '2023-12-10', 850.00, 'Shipped'),
(6, 6, '2023-12-01', 200.00, 'Shipped'),
(7, 7, '2023-12-11', 500.00, 'Shipped'),
(8, 8, '2023-11-15', 300.00, 'Pending');





-- Creating the OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Inserting sample data into OrderDetails table
INSERT INTO OrderDetails VALUES
(1, 1, 1, 1, 1200.00),
(2, 1, 2, 1, 700.00),
(3, 2, 2, 1, 700.00),
(4, 3, 3, 1, 100.00),
(5, 4, 4, 1, 150.00),
(6, 5, 5, 1, 80.00),
(7, 6, 6, 1, 180.00),
(8, 7, 7, 2, 45.00);






-- Creating the Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Inserting sample data into Payments table
INSERT INTO Payments VALUES
(1, 1, '2023-12-15', 2200.00, 'Credit Card'),
(2, 2, '2023-11-21', 800.00, 'PayPal'),
(3, 3, '2023-10-06', 150.00, 'Credit Card'),
(4, 4, '2023-09-29', 280.00, 'Credit Card'),
(5, 5, '2023-12-11', 850.00, 'PayPal'),
(6, 6, '2023-12-02', 200.00, 'Credit Card'),
(7, 7, '2023-12-12', 500.00, 'PayPal'),
(8, 8, '2023-11-16', 300.00, 'Credit Card');



# QURIES

-- 1. Find the Total Number of Orders for Each Customer
SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id;



-- 2. Find the Total Sales Amount for Each Product (Revenue per Product)
SELECT p.product_id, p.product_name, SUM(od.quantity * od.unit_price) AS total_sales
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name;



-- 3. Find the Most Expensive Product Sold
SELECT p.product_id, p.product_name, od.unit_price
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.unit_price = (
    SELECT MAX(unit_price)
    FROM OrderDetails
)
LIMIT 1;






-- 4. Get the List of Customers Who Have Placed Orders in the Last 30 Days
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;



-- 5. Calculate the Total Amount Paid by Each Customer
SELECT c.customer_id, SUM(p.payment_amount) AS total_paid
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;




-- 6. Get the Number of Products Sold by Category
SELECT p.category, SUM(od.quantity) AS total_products_sold
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.category;




-- 7. List All Orders That Are Pending (i.e., Orders that haven't been shipped yet)
SELECT * 
FROM Orders 
WHERE order_status = 'Pending';




-- 8. Find the Average Order Value (Total Order Amount / Number of Orders)
SELECT AVG(total_amount) AS average_order_value
FROM Orders;




-- 9. List the Top 5 Customers Who Have Spent the Most Money
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.payment_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;




-- 10. Find the Products That Have Never Been Sold
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.product_id IS NULL;