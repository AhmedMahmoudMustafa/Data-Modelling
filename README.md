# Dimensional Data Modeling - Actor Films

This repository demonstrates dimensional data modeling techniques using a dataset of actors and films. The goal is to transform the data into a format that is suitable for efficient analysis, particularly tracking changes in actor attributes over time.

## Dataset Overview

The `actor_films` dataset contains information about actors, films, and their associated ratings. It includes the following fields:

- `actor`: The name of the actor.
- `actorid`: A unique identifier for each actor.
- `film`: The name of the film.
- `year`: The year the film was released.
- `votes`: The number of votes the film received.
- `rating`: The rating of the film.
- `filmid`: A unique identifier for each film.

## Data Modeling Approach

The project employs the following steps:

1. **`actors` Table:**
   - Creates an `actors` table to store the current state of each actor, including their films, quality class (based on average movie rating), and activity status.
   - Utilizes a recursive CTE to populate this table incrementally, year by year.

2. **`actors_history_scd` Table:**
   - Implements a Type 2 Slowly Changing Dimension (SCD) table to track historical changes in `quality_class` and `is_active` status for each actor.
   - Includes `start_date` and `end_date` fields to capture the time periods for each status.

3. **Backfill and Incremental Queries:**
   - Provides a backfill query to populate the `actors_history_scd` table with historical data.
   - Offers an incremental query to update the SCD table with new data from the `actors` table, ensuring efficient updates.

## Queries

The `assignment_queries.sql` file contains the following SQL queries:

1. **DDL for `actors` table:** Creates the `actors` table with appropriate data types and primary key.
2. **Cumulative table generation query:** Populates the `actors` table year by year using a recursive CTE.
3. **DDL for `actors_history_scd` table:** Defines the structure of the SCD table.
4. **Backfill query for `actors_history_scd`:** Populates the SCD table with historical data.
5. **Incremental query for `actors_history_scd`:** Updates the SCD table with new data while maintaining history.

## How to Use

1. **Create a database:** Create a new database in your SQL environment.
2. **Create the `actor_films` table:** Create a table named `actor_films` with the structure described in "Dataset Overview."
3. **Populate the `actor_films` table:** Load your data into the `actor_films` table.
4. **Run the queries:** Execute the queries in the `assignment_queries.sql` file in the specified order.
