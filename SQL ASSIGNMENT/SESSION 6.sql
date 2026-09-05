--task1-- Write an SQL query using the SUM() function to calculate the total amount spent by users on food orders in a table food_orders (columns: order_id, user_id, amount) — imagine it's like Zomato's order history.

SELECT SUM(amount) AS total_amount_spent
FROM food_orders;

-- task2.-- Using the COUNT() function, find out how many songs a user has added to their playlist in a table spotify_playlists (columns: playlist_id, user_id, song_id).

SELECT user_id, COUNT(song_id) AS total_songs
FROM spotify_playlists
GROUP BY user_id;

--task3-- Write an SQL query to get the average rating given to a movie in a table bookmyshow_reviews (columns: review_id, movie_id, rating), and round the result to 1 decimal place using the ROUND() function.<br><br><em><strong>Hint:</strong> Use AVG() with ROUND() to format the output.</em>

SELECT movie_id, ROUND(AVG(rating), 1) AS average_rating
FROM bookmyshow_reviews
GROUP BY movie_id;

--task4 -- Find the minimum and maximum transaction values for a user from a table paytm_transactions (columns: txn_id, user_id, amount) — show both the smallest and largest transaction amounts.

SELECT 
    user_id,
    MIN(amount) AS minimum_transaction,
    MAX(amount) AS maximum_transaction
FROM paytm_transactions
GROUP BY user_id;

--task5-- Given a table myntra_orders (columns: order_id, user_id, total_price), write an SQL query to display the total number of orders, the average order value (rounded to 2 decimals), and the highest order value for each user_id.<br><br><em><strong>Constraint:</strong> Use GROUP BY to get results per user.</em>

SELECT 
    user_id,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_price), 2) AS average_order_value,
    MAX(total_price) AS highest_order_value
FROM myntra_orders
GROUP BY user_id;