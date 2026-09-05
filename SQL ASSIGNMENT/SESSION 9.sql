--task 1-- Create two tables, influencers and brands, with at least 3 sample rows each. Use a FULL OUTER JOIN to list all influencers and brands, showing influencer_name and brand_name, matching on city. If there is no match, display NULL for the missing side.<br><br><em><strong>Hint:</strong> Use LEFT JOIN, RIGHT JOIN, and UNION if your SQL dialect does not support FULL OUTER JOIN directly.</em>


-- Create influencers table
CREATE TABLE influencers (
    influencer_id INT PRIMARY KEY,
    influencer_name VARCHAR(100),
    city VARCHAR(50)
);

-- Insert sample data
INSERT INTO influencers VALUES
(1, 'Rahul Sharma', 'Ahmedabad'),
(2, 'Priya Patel', 'Mumbai'),
(3, 'Amit Singh', 'Delhi');

-- Create brands table
CREATE TABLE brands (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(100),
    city VARCHAR(50)
);

-- Insert sample data
INSERT INTO brands VALUES
(101, 'Nike', 'Ahmedabad'),
(102, 'Puma', 'Mumbai'),
(103, 'Adidas', 'Bangalore');

SELECT 
    i.influencer_name,
    b.brand_name
FROM influencers i
LEFT JOIN brands b
    ON i.city = b.city

UNION

SELECT 
    i.influencer_name,
    b.brand_name
FROM influencers i
RIGHT JOIN brands b
    ON i.city = b.city;
--task 2 -- Given a table called playlists with columns (id, playlist_name, parent_playlist_id), write a SELF JOIN query to display each playlist alongside its parent playlist's name, similar to how Spotify might nest playlists.

CREATE TABLE playlists (
    id INT PRIMARY KEY,
    playlist_name VARCHAR(100),
    parent_playlist_id INT
);

INSERT INTO playlists VALUES
(1, 'My Music', NULL),
(2, 'Workout Songs', 1),
(3, 'Chill Songs', 1),
(4, 'Gym Motivation', 2);

SELECT
    child.playlist_name AS playlist_name,
    parent.playlist_name AS parent_playlist_name
FROM playlists child
LEFT JOIN playlists parent
    ON child.parent_playlist_id = parent.id;


--task 3-- Create two tables: users and offers. Write a CROSS JOIN query to generate all possible combinations of users and offers, displaying user_name and offer_title. Explain in a comment how this could be used for a Flipkart-style personalized offer campaign.
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100)
);

INSERT INTO users VALUES
(1, 'Rahul'),
(2, 'Priya'),
(3, 'Amit');


CREATE TABLE offers (
    offer_id INT PRIMARY KEY,
    offer_title VARCHAR(100)
);

INSERT INTO offers VALUES
(101, '20% Off Electronics'),
(102, '₹500 Cashback'),
(103, 'Free Delivery');

SELECT
    u.user_name,
    o.offer_title
FROM users u
CROSS JOIN offers o;


--task 4 -- You have an employees table with columns (id, name, manager_id). Write a SELF JOIN to display each employee's name along with their manager's name. Then, modify your query to only show employees who do not have a manager (i.e., top-level managers).

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'Raj', NULL),
(2, 'Rahul', 1),
(3, 'Priya', 1),
(4, 'Amit', 2);

SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.id;
--task 5-- Use ChatGPT or Copilot to help you write a SQL query that finds all pairs of users from a users table who live in the same city (excluding pairs where the user is compared with themselves). Paste the query and briefly describe how the AI helped you improve or debug it.

SELECT
    u1.user_name AS user1,
    u2.user_name AS user2,
    u1.city
FROM users u1
JOIN users u2
    ON u1.city = u2.city
    AND u1.user_id < u2.user_id;