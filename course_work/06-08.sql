/*
 * процедура заполнения таблицы calculation, заполнение происходит в пределах указанного месяца с первый по последний дни месяца,
 * в учет берется только те ресурсы, у которых значения столбца conntction_date таблица client_resources не нулевые и меньше или равны
 * установленной даты. А столбец даты окончанания работы ресурса disconntction_date должна быть нулевой или соответствовать текущему
 * месяцу
*/

DELIMITER //

DROP PROCEDURE IF EXISTS calcul_cost// 
CREATE PROCEDURE calcul_cost (IN check_month DATE, IN user_i BIGINT)
BEGIN
	
	INSERT INTO calculation 
		(`client_id`,`client_resources_id`,`services_id`, `contract_id`, `start_date`, `end_date`, `user_id`)	
	SELECT
		`client_id`,
		`id`,
		`services_id`,
		`contract_id`,
		`connection_date`,
		`disconnection_date`,
		user_i
	FROM client_resources
	WHERE
		(
			connection_date IS NOT NULL
			AND
			connection_date <= check_month
		)
		AND
		(
			disconnection_date IS NULL
			OR
			(
				MONTH(disconnection_date) = MONTH(check_month)
				AND
				YEAR(disconnection_date) = YEAR(check_month)
			)
		);
	
	UPDATE
		calculation
	SET
		start_date = date_format(check_month,'%Y-%m-01')
	WHERE
		(
			YEAR(start_date) != YEAR(check_month)
			AND
			MONTH(start_date) != MONTH(check_month)
		)
		OR
		(
			YEAR(start_date) != YEAR(check_month)
		)
		OR
		(
			MONTH(start_date) != MONTH(check_month)
		)
	;
	
	UPDATE
		calculation
	SET
		end_date = LAST_DAY(check_month)
	WHERE
		end_date IS NULL;
	
	UPDATE
		calculation,		
		(
			SELECT
				calculation.id,
				ROUND(
					service_cost * (dayofmonth(end_date) - dayofmonth(start_date) + 1) / dayofmonth(LAST_DAY(check_month)),2
				) AS 'cost'
			FROM 
				calculation, services_month
			WHERE
				calculation.services_id = services_month.id
		) cal2 
	
	SET
		calculation.cost = cal2.cost
	WHERE 
		calculation.id = cal2.id;
	
END//

DELIMITER ;

CALL calcul_cost('2021-04-30', 2);

/*
 * тригер на проверку добавления данных в соответсвии с рабочими группами
 * 1 - договорной отдел
 * 2 - технический отдел
 * 3 - отдел расчета счетов
 */

DELIMITER //

DROP TRIGGER IF EXISTS input_clients//
CREATE TRIGGER input_clients BEFORE INSERT ON clients
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_clients//
CREATE TRIGGER update_clients BEFORE UPDATE ON clients
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_profile

DROP TRIGGER IF EXISTS input_client_profile//
CREATE TRIGGER input_client_profile BEFORE INSERT ON client_profile
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_profile//
CREATE TRIGGER update_client_profile BEFORE UPDATE ON client_profile
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_users

DROP TRIGGER IF EXISTS input_client_users//
CREATE TRIGGER input_client_users BEFORE INSERT ON client_users
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_users//
CREATE TRIGGER update_client_users BEFORE UPDATE ON client_users
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_bank_info

DROP TRIGGER IF EXISTS input_client_bank_info//
CREATE TRIGGER input_client_bank_info BEFORE INSERT ON client_bank_info
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_bank_info//
CREATE TRIGGER update_client_bank_info BEFORE UPDATE ON client_bank_info
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- personal_account

DROP TRIGGER IF EXISTS input_personal_account//
CREATE TRIGGER input_personal_account BEFORE INSERT ON personal_account
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_personal_account//
CREATE TRIGGER update_personal_account BEFORE UPDATE ON personal_account
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- contracts

DROP TRIGGER IF EXISTS input_contracts//
CREATE TRIGGER input_contracts BEFORE INSERT ON contracts
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_contracts//
CREATE TRIGGER update_contracts BEFORE UPDATE ON contracts
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- attorney

DROP TRIGGER IF EXISTS input_attorney//
CREATE TRIGGER input_attorney BEFORE INSERT ON attorney
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_attorney//
CREATE TRIGGER update_attorney BEFORE UPDATE ON attorney
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 2 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_info

DROP TRIGGER IF EXISTS input_client_info//
CREATE TRIGGER input_client_info BEFORE INSERT ON client_info
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_info//
CREATE TRIGGER update_client_info BEFORE UPDATE ON client_info
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_address

DROP TRIGGER IF EXISTS input_client_address//
CREATE TRIGGER input_client_address BEFORE INSERT ON client_address
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_address//
CREATE TRIGGER update_client_address BEFORE UPDATE ON client_address
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_application

DROP TRIGGER IF EXISTS input_client_application//
CREATE TRIGGER input_client_application BEFORE INSERT ON client_application
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_application//
CREATE TRIGGER update_client_application BEFORE UPDATE ON client_application
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- client_resources

DROP TRIGGER IF EXISTS input_client_resources//
CREATE TRIGGER input_client_resources BEFORE INSERT ON client_resources
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_client_resources//
CREATE TRIGGER update_client_resources BEFORE UPDATE ON client_resources
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- ot_client_resources

DROP TRIGGER IF EXISTS input_ot_client_resources//
CREATE TRIGGER input_ot_client_resources BEFORE INSERT ON ot_client_resources
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_ot_client_resources//
CREATE TRIGGER update_ot_client_resources BEFORE UPDATE ON ot_client_resources
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- calculation

DROP TRIGGER IF EXISTS input_calculation//
CREATE TRIGGER input_calculation BEFORE INSERT ON calculation
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_calculation//
CREATE TRIGGER update_calculation BEFORE UPDATE ON calculation
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

-- payment

DROP TRIGGER IF EXISTS input_payment//
CREATE TRIGGER input_payment BEFORE INSERT ON payment
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, wrong user';
	END IF;
		
END//

DROP TRIGGER IF EXISTS update_payment//
CREATE TRIGGER update_payment BEFORE UPDATE ON payment
FOR EACH ROW 
BEGIN 
	DECLARE user_group BIGINT;
	
	SELECT profile_users.work_type INTO user_group FROM	profile_users
	WHERE 
		profile_users.user_id = NEW.user_id;
	
	IF user_group != 3 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, wrong user';
	END IF;
		
END//

DELIMITER ;