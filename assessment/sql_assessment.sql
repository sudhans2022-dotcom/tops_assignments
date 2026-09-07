-- ============================================================
-- Data Analytics - Module 4 SQL Assessment (M4-A1)
-- Name: Sagar Gupta
-- Database: MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS food_delivery_assessment;
USE food_delivery_assessment;

-- ============================================================
-- SECTION A - CONCEPT APPLICATION
-- ============================================================

-- Task 1:
-- GROUP BY creates one group for each restaurant. SUM(total_amount)
-- and COUNT(order_id) calculate revenue and number of orders for
-- each group. HAVING is used because the conditions depend on
-- aggregate results.
--
-- Example:
-- SELECT restaurant_name, COUNT(*) AS total_orders,
--        SUM(total_amount) AS total_revenue
-- FROM delivery_orders
-- GROUP BY restaurant_name
-- HAVING SUM(total_amount) > 100000

--    AND COUNT(*) >= 50;
--
-- WHERE filters individual rows before grouping. HAVING filters
-- groups after aggregation. Replacing HAVING with WHERE would fail
-- because aggregate expressions such as SUM() and COUNT() cannot
-- normally be used there.

-- Task 2:
-- I would use LEFT JOIN from customers to orders. LEFT JOIN keeps
-- every customer from the left table, even when there is no matching
-- order. INNER JOIN would remove customers who have never ordered.
--
-- Example:
-- SELECT c.customer_id, c.name, o.order_id, o.order_date
-- FROM customers c
-- LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Task 3:
-- A scalar subquery is suitable because the overall platform average
-- is one single value. The outer query compares every agent average
-- with that one value.
--
-- Example:
-- SELECT agent_name, AVG(delivery_time_mins) AS avg_time
-- FROM deliveries
-- GROUP BY agent_name
-- HAVING AVG(delivery_time_mins) <
--        (SELECT AVG(delivery_time_mins) FROM deliveries);
--
-- If the subquery is put in SELECT, it would produce a value as an
-- output column rather than filtering the agents. It is not the
-- correct place when the main purpose is to filter rows/groups.

-- Task 4:
-- RANK() gives the same rank to ties and leaves a gap after the tie.
-- DENSE_RANK() also gives the same rank to ties but does not leave
-- a gap.
--
-- Example:
-- Revenue: Restaurant A = 90000, B = 85000, C = 85000
-- RANK():        1, 2, 2
-- DENSE_RANK():  1, 2, 2
--
-- If another restaurant has 80000:
-- RANK():        1, 2, 2, 4
-- DENSE_RANK():  1, 2, 2, 3
--
-- I would use DENSE_RANK for a product report when I want the next
-- performance position to be rank 3 instead of rank 4 after a tie.

-- Task 5:
-- CASE WHEN can create a calculated classification column.
-- The conditions are checked from top to bottom.
--
-- Example:
-- CASE
--   WHEN total_spend > 5000 THEN 'Platinum'
--   WHEN total_spend >= 2000 THEN 'Gold'
--   ELSE 'Standard'
-- END AS customer_tier
--
-- Exactly Rs 5,000 is Gold because the first condition is > 5000
-- and the second condition includes values >= 2000.

-- Task 6:
-- An index is a data structure that helps MySQL find matching rows
-- without scanning the whole table. An index on a frequently used
-- JOIN column can reduce the amount of data MySQL has to search.
-- This can improve a query that joins large tables.
--
-- Indexes are not always beneficial. They use disk space and make
-- INSERT, UPDATE and DELETE operations slower because the index also
-- has to be maintained. Too many indexes can therefore hurt write
-- performance and increase storage. The trade-off is read speed
-- versus storage and write/maintenance cost.

-- ============================================================
-- SECTION B - PRACTICAL CODING TASKS
-- ============================================================

-- ------------------------------------------------------------
-- TASK 1 - Menu & Order Explorer
-- ------------------------------------------------------------

DROP TABLE IF EXISTS food_orders;

CREATE TABLE food_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    restaurant_name VARCHAR(80),
    item_ordered VARCHAR(80),
    quantity INT,
    price_per_item DECIMAL(10,2),
    order_date DATE,
    city VARCHAR(40)
);

INSERT INTO food_orders VALUES
(1, 'Aarav', 'Spice Hub', 'Paneer Tikka', 2, 320.00, '2026-08-01', 'Mumbai'),
(2, 'Riya', 'Burger Point', 'Cheese Burger', 2, 280.00, '2026-08-02', 'Ahmedabad'),
(3, 'Kunal', 'Biryani House', 'Chicken Biryani', 1, 420.00, '2026-08-03', 'Surat'),
(4, 'Neha', 'Spice Hub', 'Veg Thali', 1, 380.00, '2026-08-04', 'Mumbai'),
(5, 'Rahul', 'Dragon Bowl', 'Hakka Noodles', 3, 250.00, '2026-08-05', 'Ahmedabad'),
(6, 'Priya', 'Biryani House', 'Veg Biryani', 2, 300.00, '2026-08-06', 'Surat'),
(7, 'Aman', 'Burger Point', 'Double Burger', 2, 450.00, '2026-08-07', 'Mumbai'),
(8, 'Simran', 'Dragon Bowl', 'Manchurian', 1, 290.00, '2026-08-08', 'Ahmedabad'),
(9, 'Vivek', 'Spice Hub', 'Masala Dosa', 2, 220.00, '2026-08-09', 'Mumbai'),
(10, 'Pooja', 'Biryani House', 'Mutton Biryani', 1, 520.00, '2026-08-10', 'Surat');

-- All Mumbai orders, highest price per item first
SELECT *
FROM food_orders
WHERE city = 'Mumbai'
ORDER BY price_per_item DESC;

-- Distinct restaurants that received orders
SELECT DISTINCT restaurant_name
FROM food_orders
ORDER BY restaurant_name;

-- Top 5 most expensive individual orders
SELECT order_id, customer_name, restaurant_name, item_ordered,
       quantity, price_per_item,
       quantity * price_per_item AS order_value
FROM food_orders
ORDER BY order_value DESC
LIMIT 5;


-- ------------------------------------------------------------
-- TASK 2 - Restaurant Revenue Summary
-- ------------------------------------------------------------

DROP TABLE IF EXISTS delivery_orders;

CREATE TABLE delivery_orders (
    order_id INT PRIMARY KEY,
    restaurant_name VARCHAR(80),
    city VARCHAR(40),
    total_amount DECIMAL(10,2),
    order_status VARCHAR(30),
    order_date DATE
);

INSERT INTO delivery_orders VALUES
(101, 'Spice Hub', 'Mumbai', 2400.00, 'Completed', '2026-08-01'),
(102, 'Spice Hub', 'Mumbai', 3100.00, 'Completed', '2026-08-02'),
(103, 'Spice Hub', 'Mumbai', 2800.00, 'Completed', '2026-08-03'),
(104, 'Spice Hub', 'Mumbai', 2200.00, 'Completed', '2026-08-04'),
(105, 'Burger Point', 'Ahmedabad', 1800.00, 'Completed', '2026-08-01'),
(106, 'Burger Point', 'Ahmedabad', 1600.00, 'Completed', '2026-08-02'),
(107, 'Burger Point', 'Ahmedabad', 2100.00, 'Completed', '2026-08-03'),
(108, 'Biryani House', 'Surat', 5200.00, 'Completed', '2026-08-01'),
(109, 'Biryani House', 'Surat', 4700.00, 'Completed', '2026-08-02'),
(110, 'Dragon Bowl', 'Ahmedabad', 2600.00, 'Completed', '2026-08-01'),
(111, 'Dragon Bowl', 'Ahmedabad', 2900.00, 'Completed', '2026-08-02'),
(112, 'Dragon Bowl', 'Ahmedabad', 2300.00, 'Completed', '2026-08-03');

SELECT
    restaurant_name,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    CASE
        WHEN SUM(total_amount) > 10000 THEN 'High Revenue'
        ELSE 'Moderate Revenue'
    END AS revenue_label
FROM delivery_orders
GROUP BY restaurant_name
HAVING SUM(total_amount) > 5000
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- TASK 3 - Customer-Order-Restaurant Joined Report
-- ------------------------------------------------------------

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS restaurants;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(40),
    phone VARCHAR(15)
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(80),
    cuisine_type VARCHAR(40),
    city VARCHAR(40)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

INSERT INTO customers VALUES
(1, 'Aarav', 'Mumbai', '9000000001'),
(2, 'Riya', 'Ahmedabad', '9000000002'),
(3, 'Kunal', 'Surat', '9000000003'),
(4, 'Neha', 'Mumbai', '9000000004'),
(5, 'Rahul', 'Ahmedabad', '9000000005'),
(6, 'Priya', 'Surat', '9000000006'),
(7, 'Aman', 'Mumbai', '9000000007'),
(8, 'Simran', 'Ahmedabad', '9000000008');

INSERT INTO restaurants VALUES
(1, 'Spice Hub', 'Indian', 'Mumbai'),
(2, 'Burger Point', 'Fast Food', 'Ahmedabad'),
(3, 'Biryani House', 'Indian', 'Surat'),
(4, 'Dragon Bowl', 'Chinese', 'Ahmedabad'),
(5, 'Tandoori Nights', 'North Indian', 'Mumbai'),
(6, 'South Dosa', 'South Indian', 'Surat');

INSERT INTO orders VALUES
(201, 1, 1, 850.00, '2026-08-01'),
(202, 2, 2, 620.00, '2026-08-02'),
(203, 3, 3, 920.00, '2026-08-03'),
(204, 4, 1, 740.00, '2026-08-04'),
(205, 5, 4, 680.00, '2026-08-05'),
(206, 6, 3, 760.00, '2026-08-06'),
(207, 1, 5, 540.00, '2026-08-07'),
(208, 2, 4, 490.00, '2026-08-08');

-- INNER JOIN: only customers who have an order
SELECT
    o.order_id,
    c.name AS customer_name,
    r.name AS restaurant_name,
    o.amount,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_date;

-- LEFT JOIN: all customers, including customers with no orders
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.city AS customer_city,
    o.order_id,
    o.amount,
    o.order_date,
    r.name AS restaurant_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY c.customer_id;

-- Orders where customer and restaurant are in the same city
SELECT
    o.order_id,
    c.name AS customer_name,
    c.city AS customer_city,
    r.name AS restaurant_name,
    r.city AS restaurant_city,
    o.amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE c.city = r.city;


-- ------------------------------------------------------------
-- TASK 4 - Delivery Agent Performance Ranking
-- ------------------------------------------------------------

DROP TABLE IF EXISTS deliveries;

CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    agent_name VARCHAR(50),
    restaurant_name VARCHAR(80),
    delivery_time_mins INT,
    order_date DATE
);

INSERT INTO deliveries VALUES
(301, 'Raj', 'Spice Hub', 24, '2026-08-01'),
(302, 'Raj', 'Burger Point', 28, '2026-08-02'),
(303, 'Raj', 'Dragon Bowl', 26, '2026-08-03'),
(304, 'Raj', 'Spice Hub', 31, '2026-08-04'),
(305, 'Mehul', 'Biryani House', 35, '2026-08-01'),
(306, 'Mehul', 'Dragon Bowl', 33, '2026-08-02'),
(307, 'Mehul', 'Spice Hub', 36, '2026-08-03'),
(308, 'Mehul', 'Burger Point', 30, '2026-08-04'),
(309, 'Sahil', 'Biryani House', 22, '2026-08-01'),
(310, 'Sahil', 'Spice Hub', 25, '2026-08-02'),
(311, 'Sahil', 'Dragon Bowl', 27, '2026-08-03'),
(312, 'Sahil', 'Burger Point', 24, '2026-08-04'),
(313, 'Amit', 'Spice Hub', 42, '2026-08-01'),
(314, 'Amit', 'Biryani House', 40, '2026-08-02'),
(315, 'Amit', 'Dragon Bowl', 38, '2026-08-03'),
(316, 'Amit', 'Burger Point', 35, '2026-08-04');

WITH agent_stats AS (
    SELECT
        agent_name,
        ROUND(AVG(delivery_time_mins), 2) AS avg_delivery_time
    FROM deliveries
    GROUP BY agent_name
)
SELECT
    agent_name,
    avg_delivery_time,
    RANK() OVER (ORDER BY avg_delivery_time ASC) AS speed_rank,
    ROUND((SELECT AVG(delivery_time_mins) FROM deliveries), 2)
        AS platform_average_time,
    CASE
        WHEN avg_delivery_time <=
             (SELECT AVG(delivery_time_mins) FROM deliveries)
            THEN 'On Track'
        ELSE 'Needs Improvement'
    END AS performance_status
FROM agent_stats
ORDER BY speed_rank;


-- ============================================================
-- SECTION C - MINI CAPSTONE PROJECT
-- ============================================================

DROP VIEW IF EXISTS vw_daily_order_summary;
DROP TABLE IF EXISTS capstone_orders;
DROP TABLE IF EXISTS delivery_agents;
DROP TABLE IF EXISTS capstone_restaurants;
DROP TABLE IF EXISTS capstone_customers;

CREATE TABLE capstone_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60),
    city VARCHAR(40),
    phone VARCHAR(15)
);

CREATE TABLE capstone_restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(80),
    cuisine_type VARCHAR(40),
    city VARCHAR(40)
);

CREATE TABLE delivery_agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(60),
    city VARCHAR(40)
);

CREATE TABLE capstone_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    agent_id INT,
    order_amount DECIMAL(10,2),
    delivery_time_mins INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES capstone_customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES capstone_restaurants(restaurant_id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(agent_id)
);

INSERT INTO capstone_customers VALUES
(1,'Aarav','Mumbai','9100000001'),
(2,'Riya','Ahmedabad','9100000002'),
(3,'Kunal','Surat','9100000003'),
(4,'Neha','Mumbai','9100000004'),
(5,'Rahul','Ahmedabad','9100000005'),
(6,'Priya','Surat','9100000006'),
(7,'Aman','Mumbai','9100000007'),
(8,'Simran','Ahmedabad','9100000008'),
(9,'Vivek','Surat','9100000009'),
(10,'Pooja','Mumbai','9100000010');

INSERT INTO capstone_restaurants VALUES
(1,'Spice Hub','Indian','Mumbai'),
(2,'Burger Point','Fast Food','Ahmedabad'),
(3,'Biryani House','Indian','Surat'),
(4,'Dragon Bowl','Chinese','Ahmedabad'),
(5,'Tandoori Nights','North Indian','Mumbai'),
(6,'South Dosa','South Indian','Surat'),
(7,'Pizza Corner','Italian','Mumbai'),
(8,'Curry Leaf','Indian','Ahmedabad'),
(9,'Wok Express','Chinese','Surat'),
(10,'Royal Thali','Indian','Mumbai');

INSERT INTO delivery_agents VALUES
(1,'Raj','Mumbai'),
(2,'Mehul','Ahmedabad'),
(3,'Sahil','Surat'),
(4,'Amit','Mumbai'),
(5,'Dev','Ahmedabad'),
(6,'Rohan','Surat'),
(7,'Nikhil','Mumbai'),
(8,'Varun','Ahmedabad'),
(9,'Arjun','Surat'),
(10,'Karan','Mumbai');

INSERT INTO capstone_orders VALUES
(401,1,1,1,1800,25,'2026-09-01','Completed'),
(402,1,5,4,1500,29,'2026-09-02','Completed'),
(403,1,7,7,2100,31,'2026-09-03','Completed'),
(404,1,10,10,1300,27,'2026-09-04','Completed'),
(405,2,2,2,1200,32,'2026-09-01','Completed'),
(406,2,4,5,1700,35,'2026-09-02','Completed'),
(407,2,8,8,2200,28,'2026-09-03','Completed'),
(408,3,3,3,2600,30,'2026-09-01','Completed'),
(409,3,6,6,1800,26,'2026-09-02','Completed'),
(410,3,9,9,2100,34,'2026-09-03','Completed'),
(411,4,1,1,1600,24,'2026-09-04','Completed'),
(412,4,5,4,1700,28,'2026-09-05','Completed'),
(413,5,2,2,2300,31,'2026-09-04','Completed'),
(414,5,4,5,1900,33,'2026-09-05','Completed'),
(415,6,3,3,2800,29,'2026-09-04','Completed'),
(416,6,6,6,1600,25,'2026-09-05','Completed'),
(417,7,7,7,2400,30,'2026-09-05','Completed'),
(418,7,10,10,1800,27,'2026-09-06','Completed'),
(419,8,8,8,2500,29,'2026-09-06','Completed'),
(420,9,9,9,2300,32,'2026-09-06','Completed'),
(421,10,1,1,1900,23,'2026-09-06','Completed'),
(422,10,5,4,1600,26,'2026-09-06','Completed');

-- Revenue report: restaurants with more than 3 orders
SELECT
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_revenue,
    ROUND(AVG(o.order_amount), 2) AS average_order_value
FROM capstone_restaurants r
INNER JOIN capstone_orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(o.order_id) > 3
ORDER BY total_revenue DESC;

-- Customer segmentation
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(o.order_amount), 0) AS total_spend,
    CASE
        WHEN COALESCE(SUM(o.order_amount), 0) > 5000 THEN 'Platinum'
        WHEN COALESCE(SUM(o.order_amount), 0) >= 2000 THEN 'Gold'
        ELSE 'Standard'
    END AS customer_segment
FROM capstone_customers c
LEFT JOIN capstone_orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC;

-- Top 3 restaurants in each city using DENSE_RANK
WITH restaurant_revenue AS (
    SELECT
        r.city,
        r.restaurant_name,
        SUM(o.order_amount) AS total_revenue
    FROM capstone_restaurants r
    INNER JOIN capstone_orders o
        ON r.restaurant_id = o.restaurant_id
    GROUP BY r.city, r.restaurant_id, r.restaurant_name
),
ranked_restaurants AS (
    SELECT
        city,
        restaurant_name,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM restaurant_revenue
)
SELECT city, restaurant_name, total_revenue, revenue_rank
FROM ranked_restaurants
WHERE revenue_rank <= 3
ORDER BY city, revenue_rank;

-- Most recent order for each customer
WITH recent_orders AS (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_amount,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC, o.order_id DESC
        ) AS rn
    FROM capstone_orders o
    INNER JOIN capstone_customers c
        ON o.customer_id = c.customer_id
)
SELECT customer_name, order_id, order_amount, order_date
FROM recent_orders
WHERE rn = 1
ORDER BY customer_name;

-- Saved view joining all four tables
CREATE VIEW vw_daily_order_summary AS
SELECT
    o.order_date,
    c.customer_name,
    r.restaurant_name,
    a.agent_name,
    o.order_amount,
    o.delivery_time_mins
FROM capstone_orders o
INNER JOIN capstone_customers c
    ON o.customer_id = c.customer_id
INNER JOIN capstone_restaurants r
    ON o.restaurant_id = r.restaurant_id
INNER JOIN delivery_agents a
    ON o.agent_id = a.agent_id;

-- Orders in the last 7 days relative to the newest order date in this
-- assessment data.
SELECT *
FROM vw_daily_order_summary
WHERE order_date >= (
    SELECT DATE_SUB(MAX(order_date), INTERVAL 6 DAY)
    FROM capstone_orders
)
ORDER BY order_date DESC;


-- ============================================================
-- SECTION D - AI-AUGMENTED LEARNING
-- ============================================================

-- STEP 1: Exact prompt used
-- "Write a MySQL query for a food delivery platform that finds the
-- top 3 delivery agents per city, ranked by completed orders using
-- window functions. Include each agent's average delivery time.
-- Only include agents with more than 5 completed orders in that
-- city. Sort by city alphabetically and rank ascending."

-- AI ORIGINAL QUERY (example)
-- WITH agent_summary AS (
--     SELECT city, agent_id, agent_name,
--            COUNT(*) AS completed_orders,
--            AVG(delivery_time_mins) AS avg_delivery_time
--     FROM city_deliveries
--     WHERE order_status = 'Completed'
--     GROUP BY city, agent_id, agent_name
-- ),
-- ranked AS (
--     SELECT *,
--            RANK() OVER (
--                PARTITION BY city
--                ORDER BY completed_orders DESC
--            ) AS agent_rank
--     FROM agent_summary
--     WHERE completed_orders > 5
-- )
-- SELECT city, agent_name, completed_orders,
--        avg_delivery_time, agent_rank
-- FROM ranked
-- WHERE agent_rank <= 3
-- ORDER BY city, agent_rank;

-- CORRECTED VERSION
-- The HAVING condition is applied during aggregation so agents with
-- <= 5 orders are removed before ranking. This avoids ranking agents
-- who should not be part of the report.
WITH agent_summary AS (
    SELECT
        da.city,
        da.agent_id,
        da.agent_name,
        COUNT(o.order_id) AS completed_orders,
        ROUND(AVG(o.delivery_time_mins), 2) AS avg_delivery_time
    FROM delivery_agents da
    INNER JOIN capstone_orders o
        ON da.agent_id = o.agent_id
    WHERE o.order_status = 'Completed'
    GROUP BY da.city, da.agent_id, da.agent_name
    HAVING COUNT(o.order_id) > 5
),
ranked_agents AS (
    SELECT
        city,
        agent_name,
        completed_orders,
        avg_delivery_time,
        RANK() OVER (
            PARTITION BY city
            ORDER BY completed_orders DESC
        ) AS agent_rank
    FROM agent_summary
)
SELECT
    city,
    agent_name,
    completed_orders,
    avg_delivery_time,
    agent_rank
FROM ranked_agents
WHERE agent_rank <= 3
ORDER BY city ASC, agent_rank ASC;

-- STEP 2: Test/debug note
-- The main improvement I made was to apply the more-than-5-orders
-- condition with HAVING inside the grouped agent_summary CTE.
-- This makes sure the window function ranks only qualifying agents.
-- I also used the actual capstone tables and joined delivery_agents
-- with capstone_orders, while filtering only Completed orders.
