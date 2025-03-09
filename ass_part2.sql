WITH RECURSIVE actor_history AS (
    SELECT 
        actorid AS actor_id,
        actor,
        ARRAY_AGG(ROW(year, film, votes, rating, filmid)::films) AS films,
        CASE 
            WHEN AVG(rating) > 8 THEN 'star'
            WHEN AVG(rating) > 7 AND AVG(rating) <= 8 THEN 'good'
		    WHEN AVG(rating) > 6 AND AVG(rating) <= 7 THEN 'average'
            ELSE 'bad'::quality_class
        END AS quality_class,
        TRUE AS is_active,
        AVG(rating)::double precision AS avg_rating,
        MIN(year) AS current_year
    FROM actor_films
    WHERE year = (SELECT MIN(year) FROM actor_films)
    GROUP BY actorid, actor

    UNION ALL

    SELECT
        COALESCE(t.actorid, a.actor_id) AS actor_id,
        COALESCE(t.actor, a.actor) AS actor,
        CASE
            WHEN a.films IS NULL THEN t.films
            WHEN t.films IS NOT NULL THEN a.films || t.films
            ELSE a.films
        END AS films,
        
        CASE 
            WHEN t.year IS NOT NULL THEN
                CASE 
                    WHEN t.average_rating > 8 THEN 'star'
                    WHEN t.average_rating > 7 AND t.average_rating <= 8 THEN 'good'
				    WHEN t.average_rating > 6 AND t.average_rating <= 7 THEN 'average'
                    ELSE 'bad'
                END::quality_class
            ELSE a.quality_class
        END AS quality_class,

        CASE 
            WHEN t.year IS NOT NULL THEN TRUE ELSE FALSE
        END AS is_active,

        COALESCE(t.average_rating, a.avg_rating)::double precision AS avg_rating,
        COALESCE(t.year, a.current_year + 1) AS current_year
    FROM actor_history a
    LEFT JOIN (
        SELECT 
            actorid,
            actor,
            year,
            AVG(rating) AS average_rating,
            ARRAY_AGG(ROW(year, film, votes, rating, filmid)::films) AS films
        FROM actor_films
        WHERE year > (SELECT MIN(year) FROM actor_films)
        GROUP BY actorid, actor, year
    ) t
    ON t.actorid = a.actor_id AND t.year = a.current_year + 1
    WHERE a.current_year + 1 <= (SELECT MAX(year) FROM actor_films)
)

INSERT INTO actor
SELECT *
FROM actor_history;
