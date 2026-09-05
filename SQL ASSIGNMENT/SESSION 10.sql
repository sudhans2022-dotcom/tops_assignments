
--task 1-- Create two tables: AppOrders (for orders placed via a food delivery app like Zomato) and InStoreOrders (for direct restaurant orders), each with columns: order_id, customer_name, amount, and order_date. Insert at least 3 sample records into each table.
-- Create AppOrders table
CREATE TABLE AppOrders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    order_date DATE
);

-- Insert sample records
INSERT INTO AppOrders VALUES
(101, 'Rahul', 450.00, '2026-08-25'),
(102, 'Priya', 600.00, '2026-08-26'),
(103, 'Amit', 350.00, '2026-08-27');


-- Create InStoreOrders table
CREATE TABLE InStoreOrders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    order_date DATE
);

-- Insert sample records
INSERT INTO InStoreOrders VALUES
(201, 'Neha', 500.00, '2026-08-25'),
(202, 'Rahul', 700.00, '2026-08-26'),
(203, 'Karan', 300.00, '2026-08-28');

--task 2-- Write a SQL query using UNION to combine all unique customer names from both AppOrders and InStoreOrders tables into a single list.

SELECT customer_name
FROM AppOrders

UNION

SELECT customer_name
FROM InStoreOrders;

--task 3-- Write a SQL query using UNION ALL to display every order (including duplicates if any) from both AppOrders and InStoreOrders, showing order_id, customer_name, amount, and order_date.

SELECT 
    order_id,
    customer_name,
    amount,
    order_date
FROM AppOrders

UNION ALL

SELECT 
    order_id,
    customer_name,
    amount,
    order_date
FROM InStoreOrders;

--task 4-- Demonstrate the difference between UNION and UNION ALL by adding a duplicate customer_name in both tables, then running both queries and noting the difference in the result count.<br><br><em><strong>Hint:</strong> UNION removes duplicates, UNION ALL does not.</em>

-- Add duplicate customer name
INSERT INTO AppOrders VALUES
(104, 'Neha', 400.00, '2026-08-29');

INSERT INTO InStoreOrders VALUES
(204, 'Neha', 550.00, '2026-08-29');

SELECT customer_name
FROM AppOrders

UNION

SELECT customer_name
FROM InStoreOrders;