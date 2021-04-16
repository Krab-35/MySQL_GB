DROP DATABASE IF EXISTS billing_program;
CREATE DATABASE billing_program;

USE billing_program;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL,
	first_name VARCHAR(100), -- имя
	last_name VARCHAR(100), -- фамилия
	user_password VARCHAR(120), -- хэш пароля
	password_date DATE -- дата ввода пароля, необходима для замены пароля через определённый период времени
); -- таблица пользователей биллинговой программы

DROP TABLE IF EXISTS profile_users;
CREATE TABLE profile_users(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL, -- привязка к id таблицы users
	work_type INT UNSIGNED, -- разрешение на проведение определенного типа работ
							-- (договорной отдел - 1, службы подключения услуг - 2, группа выставления счетов - 3)
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица ограничения доступа к биллинговой программы

DROP TABLE IF EXISTS services_month;
CREATE TABLE services_month(
	id SERIAL,
	service_number VARCHAR(20), -- номер оказываемой услуги по тарифам
	service_name VARCHAR(255), -- наименование услуги
	service_cost DOUBLE(20,2), -- стоимость услуги
	INDEX service_number(service_number)
); -- ежемесячные услуги

DROP TABLE IF EXISTS ot_payment;
CREATE TABLE ot_payment(
	id SERIAL,
	service_id BIGINT UNSIGNED, -- привязка к id таблицы services_month
	ot_number VARCHAR(20), -- номер разовой услуги по тарифам
	ot_name VARCHAR(255), -- наименование разовой услуги
	ot_cost DOUBLE(20,2),-- стоимость услуги
	INDEX ot_number(ot_number),
	FOREIGN KEY (service_id) REFERENCES services_month(id)
); -- разовые услуги

DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
	id SERIAL,
	client_name VARCHAR(255), 
	create_date DATETIME DEFAULT NOW(), -- дата создания клиента в БД
	user_id BIGINT UNSIGNED NOT NULL, -- пользователь, который добавил клиента в БД
	INDEX client_name(client_name),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица клиентов, которым оказываются услуги

DROP TABLE IF EXISTS client_profile;
CREATE TABLE client_profile(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	kpp VARCHAR(20), -- КПП клиента
	inn VARCHAR(20),-- ИНН клиента
	okved VARCHAR(20),-- ОКВЕД клиента
	ogrn VARCHAR(20),-- ОРГН клиента
	user_id BIGINT UNSIGNED, -- пользователь, который добавил данные клиента в БД
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица карточки клиента

DROP TABLE IF EXISTS client_users;
CREATE TABLE client_users(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	user_status VARCHAR(50), -- куратор/руководство
	first_name VARCHAR(100), -- имя
	last_name VARCHAR(100), -- фамилия
	patronymic VARCHAR(100), -- отчество
	user_id BIGINT UNSIGNED, -- пользователь, который добавил данные клиента в БД
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица с указанием куратора, генерального директора клиента

DROP TABLE IF EXISTS client_bank_info;
CREATE TABLE client_bank_info(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к клиенту
	bank_name VARCHAR(100), -- название банка
	pay_acc VARCHAR(20), -- расчетный счет
	corr_acc VARCHAR(20), -- корреспондентский счет
	client_bic VARCHAR(20), -- БИК
	user_id BIGINT UNSIGNED, -- пользователь, который добавлял данные
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- банковские реквизиты клиента

DROP TABLE IF EXISTS personal_account;
CREATE TABLE personal_account(
	id SERIAL,
	account_type CHAR(1), -- тип лицевого счета
	account_nubmer BIGINT UNSIGNED, -- номер лицевого счета, совпадает с id таблицы clients
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто создал лицевой счет
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица для начисления оказанных услуг на лицевых счетах по договорам клиентов

DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts(
	id SERIAL,
	contract_name VARCHAR(100), -- номер договора
	signing_date DATE, -- дата подписания договора
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	services_id BIGINT UNSIGNED, -- привязка к id таблицы services_month
	account_id BIGINT UNSIGNED, -- тип лицевого счета
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто составлял договор
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (services_id) REFERENCES services_month(id),
	FOREIGN KEY (account_id) REFERENCES personal_account(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица договоров клиента с указанием вида услуг и лицевых счетов

DROP TABLE IF EXISTS attorney;
CREATE TABLE attorney(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы client_users
	contract_id BIGINT UNSIGNED, -- привязка к id таблицы contracts
	attorney_text VARCHAR(255), -- текст с номером и датой доверенности, если имеется
	user_id BIGINT UNSIGNED, -- пользователь, который добавлял данные
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица доверенностей

DROP TABLE IF EXISTS client_info;
CREATE TABLE client_info(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы client_users
	contract_id BIGINT UNSIGNED, -- привязка к id таблицы contracts
	phone BIGINT UNSIGNED, -- телефон для связи с куратором по договору
	email VARCHAR(120), -- электронная почта куратора по договору
	user_id BIGINT UNSIGNED, -- пользователь, который добавил клиента в БД
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица контактной информации о клиенте

DROP TABLE IF EXISTS client_address;
CREATE TABLE client_address(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	legal_address VARCHAR(255), -- юридический адрес клиента
	physical_address VARCHAR(255), -- фактический адрес клиента
	city VARCHAR(255), -- город местонахождения
	address_index BIGINT UNSIGNED, -- почтовый индекс
	user_id BIGINT UNSIGNED, -- пользователь, который добавил клиента в БД
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица адреса, контактного телефона, электронной почты, факса клиента

DROP TABLE IF EXISTS client_application;
CREATE TABLE client_application(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	contract_id BIGINT UNSIGNED, -- привязка к id таблицы contracts
	application_number VARCHAR(120), -- номер заявки
	application_date DATE, -- дата заявки
	application_status INT(1), -- статус выполнения заявки
	user_id BIGINT UNSIGNED, -- пользователь, который добавил клиента в БД
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- заявки от клиента

DROP TABLE IF EXISTS application_users;
CREATE TABLE application_users(
	id SERIAL,
	user_id BIGINT UNSIGNED, -- привязка к id таблицы users
	application_id BIGINT UNSIGNED, -- привязка к id таблице client_application
	work_status VARCHAR(255), -- статус выполнения заявки
	work_date_start DATE, -- дата начала обработки заявки
	work_date_end DATE, -- дата конца обработки заявки
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица исполнителей по заявке

DROP TABLE IF EXISTS client_resources;
CREATE TABLE client_resources(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	contract_id BIGINT UNSIGNED, -- id договора, к которому подключен ресурс
	resource_name VARCHAR(100), -- имя ресурса
	services_id BIGINT UNSIGNED, -- id из таблицы services_month, какая услуга была подключена
	application_id BIGINT UNSIGNED, -- id из таблицы client_application. Заявка, по которой была подключена услуга
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто подключал услугу
	connection_date DATE, -- дата подключения
	disconnection_date DATE, -- дата отключения
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (services_id) REFERENCES services_month(id),
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица с подключенными ресурсами клиента

DROP TABLE IF EXISTS calculation;
CREATE TABLE calculation(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	client_resources_id BIGINT UNSIGNED, -- привязка к id таблицы client_resources
	contract_id BIGINT UNSIGNED, -- id договора, к которому подключен ресурс
	services_id BIGINT UNSIGNED, -- указание номера услуги по тарифам
	start_date DATE, -- дата начала расчета за текущий период
	end_date DATE, -- дата окончания расчета за текущий период
	cost DOUBLE(20,2), -- расчет стоимости услуги за период
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто производил начисления
	flag_status INT(1) DEFAULT 0, -- флаг учета в выставленных счетах
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (client_resources_id) REFERENCES client_resources(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица расчета стоимости услуг за месяц

DROP TABLE IF EXISTS ot_client_resources;
CREATE TABLE ot_client_resources(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	contract_id BIGINT UNSIGNED, -- id договора, к которому подключен ресурс
	resource_name VARCHAR(100), -- имя ресурса
	ot_payment_id BIGINT UNSIGNED, -- id из таблицы ot_payment, какая услуга была подключена
	application_id BIGINT UNSIGNED, -- id из таблицы client_application. Заявка, по которой была подключена услуга
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто подключал услугу
	connection_date DATE, -- дата подключения
	cost DOUBLE(20,2), -- расчет стоимости услуги за период
	flag_status INT(1) DEFAULT 0, -- флаг учета в выставленных счетах
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (ot_payment_id) REFERENCES ot_payment(id),
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица с разовыми услугами клиента

DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы clients
	client_name VARCHAR(255), -- название организации из таблицы clients
	contract_id BIGINT UNSIGNED, -- id договора, к которому подключен ресурс
	contract_name VARCHAR(255), -- номер договора из таблицы contracts
	contract_date DATE, -- дата договора из таблицы contracts
	legal_address VARCHAR(255), -- юридический адрес клиента из таблицы client_address
	physical_address VARCHAR(255), -- фактический адрес клиента из таблицы client_address
	kpp VARCHAR(20), -- КПП клиента из таблицы client_profile
	inn VARCHAR(20),-- ИНН клиента из таблицы client_profile
	account_id_group BIGINT UNSIGNED, -- группировка по id таблицы personal_account, тип лицевого счета
	services_id_group BIGINT UNSIGNED, -- группировка по id тарифных планов
	monthe_group DATE, -- группировка по месяцу
	sum_cost DOUBLE(20,2), -- суммирование стоимости оказанных услуг за месяц
	sum_nds DOUBLE(20,2), -- НДС
	sum_cost_nds DOUBLE(20,2), -- сумма платежа с учетом НДС
	invoicing_date DATE, -- дата выставления счета
	number_invoice BIGINT UNSIGNED, -- номер счета за определенный месяц
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (account_id_group) REFERENCES personal_account(id)
); -- таблица счетов, в данную таблицу попадают суммы группировок договором по услугам за месяц и разовые услуги

DROP TABLE IF EXISTS payment;
CREATE TABLE payment(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- привязка к id таблицы client
	contract_id BIGINT UNSIGNED, -- id договора, к которому подключен ресурс
	account_id_group BIGINT UNSIGNED, -- группировка по id таблицы personal_account, тип лицевого счета
	number_invoice BIGINT UNSIGNED, -- номер счета за определенный месяц
	payment_number DATE, -- номер платежного поручения
	date_payment DATE, -- дата платежа
	payment_sum DOUBLE(20,2), -- сумма платежа
	invoice_sum DOUBLE(20,2), -- сумма счета
	user_id BIGINT UNSIGNED, -- id из таблицы users, кто разносил оплату
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (account_id_group) REFERENCES personal_account(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- таблица, произведенной оплаты