
START TRANSACTION;

	INSERT INTO sample.users
		(id, name)
	VALUES
		(
			(
				SELECT id
				FROM 
					shop.users
				WHERE
					id = 1
			)
			,
			(
				SELECT name
				FROM 
					shop.users
				WHERE
					id = 1
			)
		)

	;
	
	DELETE FROM 
		shop.users
	WHERE
		id = 1
	;

COMMIT;