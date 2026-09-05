--TASK 1-- Download a sample IPL match data CSV file and load it into a new SQL table called ipl_matches using your preferred SQL tool (MySQL Workbench, DBeaver, or Azure Data Studio).

CREATE DATABASE ipl_db;

USE ipl_db;

CREATE TABLE ipl_matches (
    id INT,
    season INT,
    city VARCHAR(100),
    date DATE,
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    winner VARCHAR(100),
    venue VARCHAR(200)
);

LOAD DATA LOCAL INFILE 'C:/path/to/ipl_matches.csv'
INTO TABLE ipl_matches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ipl_matches;
--TASK 2-- Write a SQL query to select all matches where the team 'Mumbai Indians' played, then export the query results as a CSV file named mi_matches.csv.

SELECT *
FROM ipl_matches
WHERE team1 = 'Mumbai Indians'
   OR team2 = 'Mumbai Indians';

--TASK 3-- Connect Microsoft Excel to your SQL database and import the ipl_matches table. Create a simple table in Excel that shows the total matches played by each team.

SELECT team1 AS team
FROM ipl_matches

UNION ALL

SELECT team2 AS team
FROM ipl_matches;

SELECT team, COUNT(*) AS total_matches
FROM (
    SELECT team1 AS team
    FROM ipl_matches

    UNION ALL

    SELECT team2 AS team
    FROM ipl_matches
) AS teams
GROUP BY team
ORDER BY total_matches DESC;

--TASK 4-- Connect Power BI Desktop to your SQL database, import the ipl_matches table, and create a pivot chart showing the number of wins for each team.

Wins
 ^
 |                  █
 |          █       █
 |    █     █       █
 |    █     █   █   █
 +--------------------------> Team
      MI    CSK RCB KKR
Total Wins = COUNT(ipl_matches[winner])

--TASK 5-- Use Python (with pandas and sqlalchemy) to read the mi_matches.csv file, filter matches where 'Mumbai Indians' won, and insert those rows into a new SQL table called mi_wins.<br><br><em><strong>Hint:</strong> Use pandas.read_csv(), DataFrame filtering, and to_sql() for this task.</em>

import pandas as pd
from sqlalchemy import create_engine

# 1. Read CSV
df = pd.read_csv("mi_matches.csv")

print("Total MI matches:")
print(len(df))

# 2. Filter matches won by Mumbai Indians
mi_wins = df[df["winner"] == "Mumbai Indians"]

print("Matches won by Mumbai Indians:")
print(mi_wins)

# 3. Create SQLAlchemy connection
engine = create_engine(
    "mysql+mysqlconnector://root:@localhost:3306/ipl_db"
)

# 4. Insert into new SQL table
mi_wins.to_sql(
    "mi_wins",
    con=engine,
    if_exists="replace",
    index=False
)

print("mi_wins table created successfully!")

engine = create_engine(
    "mysql+mysqlconnector://root:1234@localhost:3306/ipl_db"
)

SELECT COUNT(*) AS total_mi_wins
FROM mi_wins;