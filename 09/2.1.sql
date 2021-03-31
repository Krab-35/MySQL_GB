CREATE USER 
	'shop_read'@'localhost'
IDENTIFIED BY
	'pass1';

REVOKE ALL ON
	*.*
FROM
	'shop_read'@'localhost';

GRANT SELECT ON
	shop.*
TO
	'shop_read'@'localhost';

CREATE USER 
	'shop'@'localhost'
IDENTIFIED BY
	'pass2';

REVOKE ALL ON
	*.*
FROM
	'shop'@'localhost';

GRANT ALL ON
	shop.*
TO
	'shop'@'localhost';