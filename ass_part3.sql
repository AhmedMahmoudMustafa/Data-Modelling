CREATE TABLE actors_history_scd (
	actor_id TEXT,
	actor TEXT,
	quality_class quality_class,
	is_active BOOLEAN,
	start_date INTEGER,
	end_date INTEGER,
	current_year INTEGER,
	PRIMARY KEY(actor_id, start_date, end_date)
)
