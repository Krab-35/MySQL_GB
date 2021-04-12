DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
	id SERIAL,
	input_id BIGINT,
	create_date DATETIME,
	table_name VARCHAR(10),
	input_name VARCHAR(255)
) ENGINE=ARCHIVE;


DELIMITER //

DROP TRIGGER IF EXISTS input_users_log//
CREATE TRIGGER input_users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs
		(input_id, create_date, table_name, input_name)
	VALUES
		(NEW.id, NOW(), 'users', NEW.name);
END //

DROP TRIGGER IF EXISTS input_catalogs_log//
CREATE TRIGGER input_catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs
		(input_id, create_date, table_name, input_name)
	VALUES
		(NEW.id, NOW(), 'catalogs', NEW.name);
END //

DROP TRIGGER IF EXISTS input_products_log//
CREATE TRIGGER input_products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs
		(input_id, create_date, table_name, input_name)
	VALUES
		(NEW.id, NOW(), 'products', NEW.name);
END //

DELIMITER ;