TRUNCATE TABLE `orders`;

INSERT INTO `orders`
	(`user_id`)
VALUES
	(1),
	(3)
;

SELECT 
	orders.id AS 'order_number',
	users.name,
	orders.created_at 
FROM
	`users`
JOIN 
	`orders`
WHERE
	users.id = orders.user_id
;