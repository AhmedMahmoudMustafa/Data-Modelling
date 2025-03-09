CREATE TYPE films AS (
		year INTEGER,
		film TEXT,
		votes INTEGER,
		rating REAL,
		film_id TEXT
	)

CREATE TYPE quality_class AS ENUM('star', 'good', 'average', 'bad')

CREATE TABLE actor (
	actor_id TEXT,
	actor TEXT,
	films films[],
	quality_class quality_class,
	is_active BOOLEAN,
	avg_rating REAL,
	current_year INTEGER,
	PRIMARY KEY(actor, current_year)
) 


