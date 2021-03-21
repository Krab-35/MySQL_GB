-- CRUD (create, read, update, delete, truncate)

-- написание команд INSERT

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`)
VALUES ('1', 'Dean', 'Satterield', 'orin69@example.net', '9160120629');

-- указание названий таблиц и столбцов лучше брать в обратные ковычки `...`

INSERT INTO `users` VALUES
('5', 'Reuben', 'Nienow', 'arlo515@example.org', NULL, 0);

-- передача нескольких строк в таблицу (дл€ быстродействи€ данный вариант правильнее):
INSERT INTO `users` VALUES
('2', 'Reuben', 'Nienow', 'arlo2@example.org', NULL, 2),
('3', 'Reub', 'Nienowich', 'arlo3@example.org', NULL, 3),
('4', 'Regina', 'Nairovna', 'arlo4@example.org', NULL, 4)
;

INSERT INTO `users`
SET
	firstname = 'Ivan',
	lastname = 'Petrovich',
	email = 'i.petrovich@example.org',
	phone = '9996669123'
;

-- написание команды SELECT

-- пример добавление данных из одной таблицы одной Ѕƒ в другую таблицу другой Ѕƒ,
-- парамерт WHERE задает условие выполнение команды:
INSERT INTO `users`
	(`id`, `firstname`, `lastname`)
SELECT
	`actor_id`, `first_name`, `last_name`
FROM sakila.actor 
WHERE actor_id = 100
;

-- написание команд UPDATE

-- команда UPDATE необходимо дл€ изменени€ значений строк в талицах
UPDATE `users`
SET
	firstname = 'Roman',
	lastname = 'Ivanov',
	email = 'r.ivanov@example.org'
WHERE 
	id = 3
;