# World Cup Database

## Project Overview

This project is part of the freeCodeCamp Relational Database Certification. It uses PostgreSQL and Bash scripting to import World Cup match data from a CSV file into a database.

The script reads match information from `games.csv`, inserts teams into the `teams` table if they do not already exist, and then inserts match records into the `games` table.

## Database Structure

### teams

| Column  | Type    | Description        |
| ------- | ------- | ------------------ |
| team_id | SERIAL  | Primary Key        |
| name    | VARCHAR | Team name (unique) |

### games

| Column         | Type    | Description               |
| -------------- | ------- | ------------------------- |
| game_id        | SERIAL  | Primary Key               |
| year           | INT     | Tournament year           |
| round          | VARCHAR | Competition round         |
| winner_id      | INT     | References teams(team_id) |
| opponent_id    | INT     | References teams(team_id) |
| winner_goals   | INT     | Goals scored by winner    |
| opponent_goals | INT     | Goals scored by opponent  |

## Files

### games.csv

Contains World Cup match data.

### insert_data.sh

Bash script that imports data from `games.csv` into the PostgreSQL database.

## Requirements

* PostgreSQL
* Bash
* psql command-line tool

## Setup

Create the database:

```sql
CREATE DATABASE worldcup;
```

Create the required tables:

```sql
CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(50) NOT NULL,
  winner_id INT NOT NULL REFERENCES teams(team_id),
  opponent_id INT NOT NULL REFERENCES teams(team_id),
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL
);
```

## Running the Script

Make the script executable:

```bash
chmod +x insert_data.sh
```

Run against the main database:

```bash
./insert_data.sh
```

Run against the test database:

```bash
./insert_data.sh test
```

## Features

* Reads data directly from a CSV file.
* Prevents duplicate teams from being inserted.
* Automatically retrieves team IDs.
* Inserts all World Cup game records into the database.
* Supports both production and test databases.

## Example Query

Find the winner of the 2018 World Cup Final:

```sql
SELECT t.name
FROM games g
JOIN teams t ON g.winner_id = t.team_id
WHERE g.year = 2018
AND g.round = 'Final';
```

## Author

Created as part of the freeCodeCamp Relational Database Certification.
