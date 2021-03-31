DROP PROCEDURE IF EXISTS time_now;

DELIMITER //

CREATE PROCEDURE time_now ()
BEGIN
	SET @time_n = HOUR(CURTIME());
	IF(@time_n BETWEEN 6 AND 11) THEN 
		SELECT '������ ����' AS 'greeting';
	END IF;
	IF (@time_n BETWEEN 12 and 17) THEN 
		SELECT '������ ����' AS 'greeting';
	END IF;
	IF (@time_n BETWEEN 18 AND 23) THEN 
		SELECT '������ �����' AS 'greeting';
	END IF;
	IF (@time_n BETWEEN 0 AND 5) THEN 
		SELECT '������ ����' AS 'greeting';
	END IF;
END//

DELIMITER ;

CALL time_now;