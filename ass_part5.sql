CREATE TYPE actor_scd_type AS (
	quality_class quality_class,
	is_active BOOLEAN,
	start_date INTEGER,
	end_date INTEGER
)


with last_year_scd AS(
	select * from actors_history_scd
	where end_date = 2020
	AND current_year = 2020
),
	historical_scd AS(
	select 
				actor_id ,
				actor ,
				quality_class ,
				is_active ,
				start_date ,
				end_date,
				current_year
	from actors_history_scd
	where end_date < 2020
	AND current_year = 2020
),
	this_year_scd AS(
	select *
	from actor
	where current_year = 2021
),

	unchanged_records AS (
	SELECT
			ts.actor_id ,
			ts.actor ,
			ts.quality_class ,
			ts.is_active ,
			ls.start_date ,
			ts.current_year AS end_date,
			ts.current_year AS current_year
	FROM this_year_scd ts
	JOIN last_year_scd ls
	ON ts.actor_id = ls.actor_id
	WHERE ts.quality_class = ls.quality_class
	AND ts.is_active = ls.is_active 
),

	changed_records AS (
	SELECT
			ts.actor_id ,
			ts.actor ,
		UNNEST(ARRAY[
			ROW(
			ls.quality_class ,
			ls.is_active ,
			ls.start_date ,
			ls.end_date)::actor_scd_type
			,ROW(
			ts.quality_class ,
			ts.is_active ,
			ts.current_year ,
			ts.current_year)::actor_scd_type
			]) AS records ,
			ts.current_year
	FROM this_year_scd ts
	JOIN last_year_scd ls
	ON ts.actor_id = ls.actor_id
	WHERE (ts.quality_class <> ls.quality_class
	OR ts.is_active <> ls.is_active)
),

	unnested_changed_records AS (
	select
		actor_id ,
		actor ,
		(records::actor_scd_type).quality_class,
		(records::actor_scd_type).is_active,
		(records::actor_scd_type).start_date,
		(records::actor_scd_type).end_date,
		current_year
	from changed_records
),
	new_records AS (
	select 
		ts.actor_id,
		ts.actor,
		ts.quality_class,
		ts.is_active,
		ts.current_year as start_date,
		ts.current_year as end_date,
		ts.current_year as current_year
	from this_year_scd ts
	left join last_year_scd ls	
	on ts.actor_id = ls.actor_id
)
select * from unnested_changed_records

union all

select * from new_records

union all

select * from unchanged_records

union all

select * from historical_scd
