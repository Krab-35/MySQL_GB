-- 1.1 задание

UPDATE `users`
SET created_at = NOW(),
	updated_at = NOW()
;

-- 1.2 задание

ALTER TABLE `users`
	MODIFY created_at DATETIME DEFAULT NOW(),
	MODIFY updated_at DATETIME DEFAULT NOW()
;

-- 1.3 задание

TRUNCATE TABLE `storehouses_products`;
INSERT INTO `storehouses_products`
	(storehouse_id, product_id, value)
VALUES
	(1, 1, 0),
	(2, 20, 2500),
	(3, 13, 0),
	(4, 57, 30),
	(5, 7, 500),
	(6, 89, 1)
;
 
(SELECT * FROM `storehouses_products`
WHERE
	value > 0
ORDER BY
	value)
UNION
(SELECT * FROM `storehouses_products`
WHERE
	value = 0)
;

-- 1.4 задание

SELECT * FROM `users`
WHERE
	MONTH(birthday_at) IN (5, 8);

-- 1.5 задание

SELECT * FROM `catalogs`
WHERE
	id IN (5, 1, 2)
ORDER BY
	FIELD(id, 5, 1, 2)
;

-- 2.1 задание

SELECT
	FLOOR(sum(FLOOR((TO_DAYS(NOW())-TO_DAYS(birthday_at))/365.25))/COUNT(id))AS 'age_v1',
	FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS 'age_v2'
FROM
	users
;

SELECT
	name,
	FLOOR((TO_DAYS(NOW())-TO_DAYS(birthday_at))/365.25) AS 'age'
FROM
	users
;

-- 2.2 задание

SELECT
	GROUP_CONCAT(name ORDER BY name SEPARATOR ', ') AS 'names',
	CASE (WEEKDAY(birthday_at))
		WHEN 0 THEN 'monday'
		WHEN 1 THEN 'tuesday'
		WHEN 2 THEN 'wedneshday'
		WHEN 3 THEN 'thursday'
		WHEN 4 THEN 'friday'
		WHEN 5 THEN 'saturday'
		WHEN 6 THEN 'sunday'
	END	AS 'days_of_week',
	COUNT(WEEKDAY(birthday_at)) AS 'count_bd'
FROM
	users
GROUP BY
	days_of_week
ORDER BY
	WEEKDAY(birthday_at)
;