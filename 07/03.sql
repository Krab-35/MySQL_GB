DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights` (
	`id` SERIAL,
	`from` VARCHAR(255),
	`to` VARCHAR(255)	
)
;

DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
	`label` VARCHAR(255),
	`name` VARCHAR(255)	
)
;

TRUNCATE TABLE `flights`;
INSERT INTO `flights`
	(`from`, `to`)
VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan')
;

TRUNCATE TABLE `cities`;
INSERT INTO `cities`
	(`label`, `name`)
VALUES
	('moscow', 'Москва'),
	('novgorod', 'Новгород'),
	('irkutsk', 'Иркутск'),
	('omsk', 'Омск'),
	('kazan', 'Казань')
;

-- easy version:

SELECT
	id,
	c1.name AS 'from',
	c2.name AS 'to'
FROM 
	flights
INNER JOIN
	cities AS c1
ON
	flights.`from` = c1.label
INNER JOIN 
	cities AS c2
ON 
	flights.`to` = c2.label 
ORDER BY 
	id
;

-- mad version:

SELECT
	table_from.id,
	table_from.`from`,
	table_to.`to`
	
FROM 
	(
		SELECT
			id,
			cities.name AS 'from'
		FROM 
			flights
		JOIN
			cities
		ON
			flights.`from` = cities.label	
		ORDER BY 
			id
	) AS `table_from`
JOIN 
	(
		SELECT
			id,
			cities.name AS 'to'
		FROM 
			flights
		JOIN
			cities
		ON
			flights.`to` = cities.label	
		ORDER BY 
			id
	) AS `table_to`
ON 
	table_from.id = table_to.id
ORDER BY table_from.id
;