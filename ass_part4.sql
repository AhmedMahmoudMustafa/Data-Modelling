INSERT INTO actors_history_scd
WITH with_previous AS (
		select 
		actor_id,
		actor,
		quality_class,
		is_active,
		LAG(quality_class) OVER (PARTITION  BY actor ORDER BY current_year) AS previous_quality_class,
		LAG(is_active) OVER (PARTITION  BY actor ORDER BY current_year) AS previous_is_active,
		current_year
		from actor
		where current_year <= 2020
	
),
	with_indicator AS (
		select *,
		CASE 
			WHEN is_active <> previous_is_active then 1
			WHEN quality_class <> previous_quality_class then 1
			ELSE 0
		 END AS change_indicator
		 from with_previous
),
	
	with_streak AS (
  		SELECT *, 
		SUM(change_indicator) OVER (PARTITION BY actor ORDER BY current_year) AS streak_identifier
		from with_indicator
	)
	

select
	   actor_id,
	   actor,
	   quality_class,
	   is_active,
	   MIN(current_year) as start_date,
	   MAX(current_year) as end_date,
	   2020 AS current_year
FROM with_indicator
GROUP BY 1,2,3,4
