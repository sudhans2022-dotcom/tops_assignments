
--TASK 1-- Create a table called Orders with columns: order_id, user_id, order_amount, and app_name (e.g., 'Zomato', 'Swiggy', 'Flipkart'). Insert at least 10 sample records with different users and apps. Write an SQL query using the OVER() function to display each order's amount along with the total order amount for all orders.

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_amount DECIMAL(10,2),
    app_name VARCHAR(50)
);


INSERT INTO Orders (order_id, user_id, order_amount, app_name)
VALUES
(1, 101, 450.00, 'Zomato'),
(2, 102, 700.00, 'Swiggy'),
(3, 101, 300.00, 'Flipkart'),
(4, 103, 1200.00, 'Zomato'),
(5, 104, 550.00, 'Swiggy'),
(6, 102, 900.00, 'Flipkart'),
(7, 105, 350.00, 'Zomato'),
(8, 103, 800.00, 'Swiggy'),
(9, 104, 650.00, 'Flipkart'),
(10, 105, 1000.00, 'Zomato');

SELECT
    order_id,
    user_id,
    order_amount,
    app_name,
    SUM(order_amount) OVER() AS total_order_amount
FROM Orders;

--TASK 2-- Using the Orders table, write an SQL query to show each user's order_id, order_amount, and the average order_amount for that user using the OVER(PARTITION BY user_id) clause.<br><br><em><strong>Hint:</strong> Use AVG(order_amount) OVER(PARTITION BY user_id) to get the per-user average.</em>

SELECT
    user_id,
    order_id,
    order_amount,
    AVG(order_amount) OVER(PARTITION BY user_id) AS user_average_amount
FROM Orders;

--TASK 3-- Suppose you have a table called Playlist with columns: song_id, user_id, and duration_sec. Write an SQL query to display each song's duration, and the total duration of songs added by each user using SUM(duration_sec) OVER(PARTITION BY user_id).

SELECT
    song_id,
    user_id,
    duration_sec,
    SUM(duration_sec) OVER(PARTITION BY user_id) AS total_duration
FROM Playlist;

--TASK 4-- Given a table named MovieRatings with columns: rating_id, user_id, movie_name, and rating (1-5), write an SQL query to show each rating, the average rating per movie, and the difference between the user's rating and the movie's average rating using window functions.<br><br><em><strong>Hint:</strong> Use AVG(rating) OVER(PARTITION BY movie_name) and subtract it from the user's rating.</em>

SELECT
    rating_id,
    user_id,
    movie_name,
    rating,
    AVG(rating) OVER(PARTITION BY movie_name) AS movie_average_rating,
    rating - AVG(rating) OVER(PARTITION BY movie_name) AS difference_from_average
FROM MovieRatings;