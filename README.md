# Dimensional Data Modeling - Actor Films

## Overview

This project demonstrates the application of dimensional data modeling techniques to analyze actor career data. The primary goal is to transform raw data into a structured format that facilitates efficient analysis of actor performance, career trends, and historical changes in actor attributes.

This project addresses the challenges of tracking actor performance over time and provides a robust foundation for data-driven decision-making in the entertainment industry.

## Key Concepts Demonstrated

* **SQL Development:** Creating and executing SQL queries for data transformation, aggregation, and retrieval.
* **Type 2 Slowly Changing Dimension (SCD):** Implementing SCD Type 2 to track historical changes in actor attributes (quality class and activity status).
* **Recursive Common Table Expressions (CTEs):** Utilizing recursive CTEs for efficient data processing and cumulative table generation.
* **Data Analysis Enablement:** Structuring data to support analysis of actor performance, career trends, and historical changes.

## Dataset

The project utilizes a dataset containing information about actors, films, and their associated attributes. The dataset includes the following fields:

* `actor`: The name of the actor.
* `actorid`: A unique identifier for each actor.
* `film`: The name of the film.
* `year`: The year the film was released.
* `votes`: The number of votes the film received.
* `rating`: The rating of the film.
* `filmid`: A unique identifier for each film.

## Data Model

The project involves the creation of two key tables:

1.  **`actor` Table:**
    * This table stores the current state of each actor, including:
        * `films`: An array of film information (film name, votes, rating, film ID).
        * `quality_class`: An actor's performance quality category (star, good, average, bad), determined by the average rating of their movies in the most recent year.
        * `is_active`: A boolean indicating whether the actor is currently active.
    * This table is populated using a recursive CTE to process data year by year.

2.  **`actors_history_scd` Table:**
    * This table implements Type 2 Slowly Changing Dimension (SCD) to track historical changes in actor attributes over time.
    * It includes the following fields:
        * `actor_id`, `actor`: Actor identification.
        * `quality_class`: Actor's performance quality category.
        * `is_active`: Actor's activity status.
        * `start_date`, `end_date`: Date range for which the record is valid.
    * This table is populated using a backfill query and can be updated incrementally using an incremental query.

## Queries

The `assignment_queries.sql` file contains the following SQL queries:

1.  **DDL for `actor` table:**
    * Creates the `actor` table and defines the custom `films` type and `quality_class` enum.

2.  **Cumulative table generation query:**
    * Uses a recursive CTE to populate the `actor` table with data, processing the data year by year.

3.  **DDL for `actors_history_scd` table:**
    * Defines the table structure for the SCD Type 2 implementation.

4.  **Backfill query for `actors_history_scd`:**
    * Populates the `actors_history_scd` table with historical data from the `actor` table.

5.  **Incremental query for `actors_history_scd`:**
    * Updates the `actors_history_scd` table with new data from the `actor` table, maintaining historical records.

## Business Impact

This project demonstrates how data modeling can be used to provide valuable insights for businesses in the entertainment industry.

* **Improved Decision-Making:** The `actor_history_scd` table enables analysis of actor performance trends and historical activity, supporting data-driven decisions in casting, project selection, and talent management.
* **Enhanced Data Understanding:** The dimensional model provides a clear and structured view of actor career data, facilitating a deeper understanding of actor-film relationships and career trajectories.
* **Increased Efficiency:** The optimized queries and data model reduce the time and resources required for data analysis, enabling stakeholders to focus on strategic initiatives.
* **Data-Driven Storytelling:** The structured data enables the creation of compelling narratives about actor careers and film industry trends, supporting effective communication with stakeholders.
* **Scalability and Maintainability:** The dimensional data model and SCD Type 2 implementation are designed to accommodate growing datasets and evolving business requirements, ensuring long-term value.
