-- 1 задание.
-- Упростил бы запрос в таком вид (подключил три таблицы и в команде на проверку условия, задавал бы только один id):

SELECT
	lastname,
	firstname, 
	p.hometown,
	m.filename 
FROM users u, profiles p, media m
WHERE
	u.id = 1 AND p.user_id = u.id AND m.user_id = u.id
;

-- 2 задание.
-- для пользователя с id=9 код выдает человека, находящийся в друзьях 9,
-- который больше всех оправлял сообщений пользователю с id=9

SELECT 
	firstname,
	lastname
FROM
	users
WHERE
	id = (
		SELECT 
			from_user_id
		FROM messages
		WHERE
			from_user_id IN (
				SELECT initiator_user_id 
				FROM friend_requests
				WHERE
					target_user_id = 9 AND status = 'approved'	
			)
		GROUP BY from_user_id
		ORDER BY COUNT(from_user_id) DESC
		LIMIT 1
	)
;

-- задание 3

SELECT COUNT(id)
FROM likes
WHERE
	user_id IN (
		SELECT * FROM (
			SELECT user_id
			FROM profiles
			ORDER BY TIMESTAMPDIFF(YEAR, birthday, NOW())
			LIMIT 10
			) AS smth
	)
;

-- задание 4

SELECT IF(
	(
	SELECT COUNT(user_id)
	FROM (
		SELECT
			user_id
		FROM
			profiles
		WHERE
			gender = 'm'
	) AS smth1
	)
	>
	(
	SELECT COUNT(user_id)
	FROM (
		SELECT
			user_id
		FROM
			profiles
		WHERE
			gender = 'f'
	) AS smth1
	),
	'male more female',
	'female more male'
)