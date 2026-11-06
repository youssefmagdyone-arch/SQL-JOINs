USE Task40DB;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Customers_Raw', 'U') IS NOT NULL DROP TABLE dbo.Customers_Raw;
GO

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(30)
);

INSERT INTO Customers VALUES
(1, 'Ahmed', 'Ali', 'ahmed@mail.com', 'Cairo'),
(2, 'Sara', 'Hassan', 'sara@mail.com', 'Giza'),
(3, 'Omar', 'Khaled', 'omar@mail.com', 'Cairo'),
(4, 'Mona', 'Samir', 'mona@mail.com', 'Alex'),
(5, 'Youssef', 'Adel', 'youssef@mail.com', 'Giza');

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 1200),
(102, 'Headphones', 'Electronics', 150),
(103, 'T-Shirt', 'Clothes', 50),
(104, 'Coffee', 'Food', 20),
(105, 'Jacket', 'Clothes', 300);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    qty INT NOT NULL,
    order_date DATE,
    status VARCHAR(20),
    payment_method VARCHAR(20),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT FK_Orders_Products FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

INSERT INTO Orders VALUES
(1, 1, 101, 1, '2026-01-05', 'Paid', 'Card'),
(2, 2, 103, 3, '2026-01-07', 'Paid', 'Cash'),
(3, 1, 102, 2, '2026-01-10', 'Pending', 'Card'),
(4, 3, 101, 1, '2026-01-12', 'Paid', 'Cash'),
(5, 4, 104, 5, '2026-01-15', 'Paid', 'Card');

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    manager_id INT NULL,
    CONSTRAINT FK_Employees_Manager FOREIGN KEY (manager_id)
        REFERENCES Employees(emp_id)
);

INSERT INTO Employees VALUES
(1, 'Hany', NULL),
(2, 'Laila', 1),
(3, 'Karim', 1),
(4, 'Dina', 2);

CREATE TABLE Customers_Raw (
    id INT,
    name VARCHAR(50),
    city VARCHAR(30),
    phone VARCHAR(30),
    join_date VARCHAR(20)
);

INSERT INTO Customers_Raw VALUES
(1, ' ahmed ', 'cairo', '0100-123-4567', '2026-01-05'),
(2, 'SARA', 'Giza ', NULL, '07/01/2026'),
(3, ' Omar ', 'CAIRO', '01001234567', '2026-01-12'),
(3, ' Omar ', 'CAIRO', '01001234567', '2026-01-12'),
(4, 'mona', ' Alex ', '0122 555 8899', '2026-01-15'),
(5, 'youssef', 'GIZA', '0111-222-3333', '2026-13-40');

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Employees;
SELECT * FROM Customers_Raw;




SELECT
    O.order_id,
    C.first_name + ' ' + C.last_name AS CustomerName,
    O.order_date
FROM Orders O
INNER JOIN Customers C
    ON O.customer_id = C.customer_id;


   
SELECT
    C.customer_id,
    C.first_name + ' ' + C.last_name AS CustomerName,
    O.order_id
FROM Customers C
LEFT JOIN Orders O
    ON C.customer_id = O.customer_id;




    
SELECT
    P.product_id,
    P.product_name,
    O.order_id
FROM Products P
LEFT JOIN Orders O
    ON P.product_id = O.product_id;

    
SELECT
    C.customer_id,
    C.first_name,
    C.last_name
FROM Customers C
LEFT JOIN Orders O
    ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;



SELECT
    P.product_id,
    P.product_name
FROM Products P
LEFT JOIN Orders O
    ON P.product_id = O.product_id
WHERE O.order_id IS NULL;



SELECT
    C.first_name + ' ' + C.last_name AS CustomerName,
    P.product_name,
    O.qty,
    P.price,
    O.order_date
FROM Orders O
INNER JOIN Customers C
    ON O.customer_id = C.customer_id
INNER JOIN Products P
    ON O.product_id = P.product_id;


SELECT
    O.order_id,
    O.customer_id,
    C.first_name + ' ' + C.last_name AS CustomerName,
    O.order_date
FROM Orders O
LEFT JOIN Customers C
    ON O.customer_id = C.customer_id;



SELECT
    E.employee_name AS EmployeeName,
    M.employee_name AS ManagerName
FROM Employees E
LEFT JOIN Employees M
    ON E.manager_id = M.emp_id;




SELECT
    C.customer_id,
    C.first_name + ' ' + C.last_name AS CustomerName,
    ISNULL(SUM(O.qty * P.price), 0) AS TotalSpent
FROM Customers C
LEFT JOIN Orders O
    ON C.customer_id = O.customer_id
LEFT JOIN Products P
    ON O.product_id = P.product_id
GROUP BY
    C.customer_id,
    C.first_name,
    C.last_name;


SELECT
    C.city,
    SUM(O.qty * P.price) AS TotalRevenue
FROM Customers C
INNER JOIN Orders O
    ON C.customer_id = O.customer_id
INNER JOIN Products P
    ON O.product_id = P.product_id
GROUP BY C.city
ORDER BY TotalRevenue DESC;


SELECT
    C.first_name + ' ' + C.last_name AS CustomerName,
    COUNT(O.order_id) AS TotalOrders
FROM Customers C
LEFT JOIN Orders O
    ON C.customer_id = O.customer_id
GROUP BY
    C.customer_id,
    C.first_name,
    C.last_name;



SELECT
    P.product_name,
    ISNULL(SUM(O.qty), 0) AS TotalQuantity
FROM Products P
LEFT JOIN Orders O
    ON P.product_id = O.product_id
GROUP BY P.product_id, P.product_name;


SELECT
    P.category,
    SUM(O.qty * P.price) AS TotalRevenue
FROM Products P
INNER JOIN Orders O
    ON P.product_id = O.product_id
GROUP BY P.category
ORDER BY TotalRevenue DESC;



SELECT
    C.first_name + ' ' + C.last_name AS CustomerName,
    AVG(O.qty * P.price) AS AverageOrderValue
FROM Customers C
INNER JOIN Orders O
    ON C.customer_id = O.customer_id
INNER JOIN Products P
    ON O.product_id = P.product_id
GROUP BY
    C.customer_id,
    C.first_name,
    C.last_name;

   
SELECT
    C.first_name + ' ' + C.last_name AS CustomerName,
    SUM(O.qty * P.price) AS TotalSpending
FROM Customers C
INNER JOIN Orders O
    ON C.customer_id = O.customer_id
INNER JOIN Products P
    ON O.product_id = P.product_id
GROUP BY
    C.customer_id,
    C.first_name,
    C.last_name
HAVING SUM(O.qty * P.price) > 500;



SELECT
    P.category,
    COUNT(DISTINCT O.order_id) AS TotalOrders,
    SUM(O.qty * P.price) AS TotalRevenue
FROM Products P
INNER JOIN Orders O
    ON P.product_id = O.product_id
GROUP BY P.category;



SELECT TOP 3
    P.product_name,
    SUM(O.qty * P.price) AS TotalRevenue
FROM Products P
INNER JOIN Orders O
    ON P.product_id = O.product_id
GROUP BY P.product_id, P.product_name
ORDER BY TotalRevenue DESC;


SELECT
    YEAR(O.order_date) AS OrderYear,
    MONTH(O.order_date) AS OrderMonth,
    SUM(O.qty * P.price) AS TotalRevenue
FROM Orders O
INNER JOIN Products P
    ON O.product_id = P.product_id
GROUP BY
    YEAR(O.order_date),
    MONTH(O.order_date)
ORDER BY
    OrderYear,
    OrderMonth;

SELECT
    id,
    name,
    city,
    phone,
    join_date,
    COUNT(*) AS DuplicateCount
FROM Customers_Raw
GROUP BY
    id,
    name,
    city,
    phone,
    join_date
HAVING COUNT(*) > 1;






SELECT
    O.order_id,
    P.product_name,
    P.category,
    O.qty,
    P.price,
    O.qty * P.price AS OriginalTotal,

    CASE
        WHEN P.category = 'Electronics' AND O.qty >= 2
        THEN O.qty * P.price * 0.90
        ELSE O.qty * P.price
    END AS NetTotal

FROM Orders O
INNER JOIN Products P
    ON O.product_id = P.product_id;


