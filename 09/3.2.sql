DROP TRIGGER IF EXISTS check_input_prod;

DELIMITER //

CREATE TRIGGER check_input_prod BEFORE INSERT ON products
FOR EACH ROW
BEGIN 
	DECLARE error_flag INT; -- флаг на проверку возникноврения двойной вставки NULL
	DECLARE output_text varchar(255); -- название продукта берется из табл. catalogs в соответсвии с id
	SET error_flag = 0;
	-- проверка вставки NULL значений:
	IF NEW.name IS NULL THEN
		SET error_flag = error_flag + 1;
	END IF;
	IF NEW.description IS NULL THEN
		SET error_flag = error_flag + 1;
	END IF;
	-- сообщение ошибки при двойной вставке NULL:
	IF error_flag = 2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
	END IF;
	-- отрабока выполнения условий задачи на замену NULL значений
	IF NEW.catalog_id > 0 THEN
		SELECT name INTO output_text FROM catalogs WHERE id = NEW.catalog_id;
		IF NEW.name IS NULL THEN
			SET NEW.name = output_text;
		END IF;
		IF NEW.description IS NULL THEN
			SET NEW.description = output_text;
		END IF;
	END IF;
	-- условие, если id = NULL и не возможно определить, к какому типу товаров относится продукт
	IF NEW.catalog_id IS NULL THEN
		SET NEW.catalog_id = 999;
		IF NEW.name IS NULL THEN
			SET NEW.name = 'product';
		END IF;
		IF NEW.description IS NULL THEN
			SET NEW.description = 'product';
		END IF;
	END IF;
END//

-- тестовые значения:
DELIMITER ;

INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	('test1', NULL, 500, 2)
;
INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	(NULL, 'test2', 500, 1)
;
INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	(NULL, NULL, 500, 3)
;
INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	('test3', NULL, 500, NULL)
;
INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	(NULL, 'test4', 500, NULL)
;