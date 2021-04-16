DROP DATABASE IF EXISTS billing_program;
CREATE DATABASE billing_program;

USE billing_program;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL,
	first_name VARCHAR(100), -- ���
	last_name VARCHAR(100), -- �������
	user_password VARCHAR(120), -- ��� ������
	password_date DATE -- ���� ����� ������, ���������� ��� ������ ������ ����� ����������� ������ �������
); -- ������� ������������� ����������� ���������

DROP TABLE IF EXISTS profile_users;
CREATE TABLE profile_users(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL, -- �������� � id ������� users
	work_type INT UNSIGNED, -- ���������� �� ���������� ������������� ���� �����
							-- (���������� ����� - 1, ������ ����������� ����� - 2, ������ ����������� ������ - 3)
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ����������� ������� � ����������� ���������

DROP TABLE IF EXISTS services_month;
CREATE TABLE services_month(
	id SERIAL,
	service_number VARCHAR(20), -- ����� ����������� ������ �� �������
	service_name VARCHAR(255), -- ������������ ������
	service_cost DOUBLE(20,2), -- ��������� ������
	INDEX service_number(service_number)
); -- ����������� ������

DROP TABLE IF EXISTS ot_payment;
CREATE TABLE ot_payment(
	id SERIAL,
	service_id BIGINT UNSIGNED, -- �������� � id ������� services_month
	ot_number VARCHAR(20), -- ����� ������� ������ �� �������
	ot_name VARCHAR(255), -- ������������ ������� ������
	ot_cost DOUBLE(20,2),-- ��������� ������
	INDEX ot_number(ot_number),
	FOREIGN KEY (service_id) REFERENCES services_month(id)
); -- ������� ������

DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
	id SERIAL,
	client_name VARCHAR(255), 
	create_date DATETIME DEFAULT NOW(), -- ���� �������� ������� � ��
	user_id BIGINT UNSIGNED NOT NULL, -- ������������, ������� ������� ������� � ��
	INDEX client_name(client_name),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ��������, ������� ����������� ������

DROP TABLE IF EXISTS client_profile;
CREATE TABLE client_profile(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	kpp VARCHAR(20), -- ��� �������
	inn VARCHAR(20),-- ��� �������
	okved VARCHAR(20),-- ����� �������
	ogrn VARCHAR(20),-- ���� �������
	user_id BIGINT UNSIGNED, -- ������������, ������� ������� ������ ������� � ��
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� �������� �������

DROP TABLE IF EXISTS client_users;
CREATE TABLE client_users(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	user_status VARCHAR(50), -- �������/�����������
	first_name VARCHAR(100), -- ���
	last_name VARCHAR(100), -- �������
	patronymic VARCHAR(100), -- ��������
	user_id BIGINT UNSIGNED, -- ������������, ������� ������� ������ ������� � ��
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� � ��������� ��������, ������������ ��������� �������

DROP TABLE IF EXISTS client_bank_info;
CREATE TABLE client_bank_info(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � �������
	bank_name VARCHAR(100), -- �������� �����
	pay_acc VARCHAR(20), -- ��������� ����
	corr_acc VARCHAR(20), -- ����������������� ����
	client_bic VARCHAR(20), -- ���
	user_id BIGINT UNSIGNED, -- ������������, ������� �������� ������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ���������� ��������� �������

DROP TABLE IF EXISTS personal_account;
CREATE TABLE personal_account(
	id SERIAL,
	account_type CHAR(1), -- ��� �������� �����
	account_nubmer BIGINT UNSIGNED, -- ����� �������� �����, ��������� � id ������� clients
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� ������ ������� ����
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ��� ���������� ��������� ����� �� ������� ������ �� ��������� ��������

DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts(
	id SERIAL,
	contract_name VARCHAR(100), -- ����� ��������
	signing_date DATE, -- ���� ���������� ��������
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	services_id BIGINT UNSIGNED, -- �������� � id ������� services_month
	account_id BIGINT UNSIGNED, -- ��� �������� �����
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� ��������� �������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (services_id) REFERENCES services_month(id),
	FOREIGN KEY (account_id) REFERENCES personal_account(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ��������� ������� � ��������� ���� ����� � ������� ������

DROP TABLE IF EXISTS attorney;
CREATE TABLE attorney(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� client_users
	contract_id BIGINT UNSIGNED, -- �������� � id ������� contracts
	attorney_text VARCHAR(255), -- ����� � ������� � ����� ������������, ���� �������
	user_id BIGINT UNSIGNED, -- ������������, ������� �������� ������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� �������������

DROP TABLE IF EXISTS client_info;
CREATE TABLE client_info(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� client_users
	contract_id BIGINT UNSIGNED, -- �������� � id ������� contracts
	phone BIGINT UNSIGNED, -- ������� ��� ����� � ��������� �� ��������
	email VARCHAR(120), -- ����������� ����� �������� �� ��������
	user_id BIGINT UNSIGNED, -- ������������, ������� ������� ������� � ��
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ���������� ���������� � �������

DROP TABLE IF EXISTS client_address;
CREATE TABLE client_address(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	legal_address VARCHAR(255), -- ����������� ����� �������
	physical_address VARCHAR(255), -- ����������� ����� �������
	city VARCHAR(255), -- ����� ���������������
	address_index BIGINT UNSIGNED, -- �������� ������
	user_id BIGINT UNSIGNED, -- ������������, ������� ������� ������� � ��
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ������, ����������� ��������, ����������� �����, ����� �������

DROP TABLE IF EXISTS client_application;
CREATE TABLE client_application(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	contract_id BIGINT UNSIGNED, -- �������� � id ������� contracts
	application_number VARCHAR(120), -- ����� ������
	application_date DATE, -- ���� ������
	application_status INT(1), -- ������ ���������� ������
	user_id BIGINT UNSIGNED, -- ������������, ������� ������� ������� � ��
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������ �� �������

DROP TABLE IF EXISTS application_users;
CREATE TABLE application_users(
	id SERIAL,
	user_id BIGINT UNSIGNED, -- �������� � id ������� users
	application_id BIGINT UNSIGNED, -- �������� � id ������� client_application
	work_status VARCHAR(255), -- ������ ���������� ������
	work_date_start DATE, -- ���� ������ ��������� ������
	work_date_end DATE, -- ���� ����� ��������� ������
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ������������ �� ������

DROP TABLE IF EXISTS client_resources;
CREATE TABLE client_resources(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	contract_id BIGINT UNSIGNED, -- id ��������, � �������� ��������� ������
	resource_name VARCHAR(100), -- ��� �������
	services_id BIGINT UNSIGNED, -- id �� ������� services_month, ����� ������ ���� ����������
	application_id BIGINT UNSIGNED, -- id �� ������� client_application. ������, �� ������� ���� ���������� ������
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� ��������� ������
	connection_date DATE, -- ���� �����������
	disconnection_date DATE, -- ���� ����������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (services_id) REFERENCES services_month(id),
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� � ������������� ��������� �������

DROP TABLE IF EXISTS calculation;
CREATE TABLE calculation(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	client_resources_id BIGINT UNSIGNED, -- �������� � id ������� client_resources
	contract_id BIGINT UNSIGNED, -- id ��������, � �������� ��������� ������
	services_id BIGINT UNSIGNED, -- �������� ������ ������ �� �������
	start_date DATE, -- ���� ������ ������� �� ������� ������
	end_date DATE, -- ���� ��������� ������� �� ������� ������
	cost DOUBLE(20,2), -- ������ ��������� ������ �� ������
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� ���������� ����������
	flag_status INT(1) DEFAULT 0, -- ���� ����� � ������������ ������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (client_resources_id) REFERENCES client_resources(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� ������� ��������� ����� �� �����

DROP TABLE IF EXISTS ot_client_resources;
CREATE TABLE ot_client_resources(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	contract_id BIGINT UNSIGNED, -- id ��������, � �������� ��������� ������
	resource_name VARCHAR(100), -- ��� �������
	ot_payment_id BIGINT UNSIGNED, -- id �� ������� ot_payment, ����� ������ ���� ����������
	application_id BIGINT UNSIGNED, -- id �� ������� client_application. ������, �� ������� ���� ���������� ������
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� ��������� ������
	connection_date DATE, -- ���� �����������
	cost DOUBLE(20,2), -- ������ ��������� ������ �� ������
	flag_status INT(1) DEFAULT 0, -- ���� ����� � ������������ ������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (ot_payment_id) REFERENCES ot_payment(id),
	FOREIGN KEY (application_id) REFERENCES client_application(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- ������� � �������� �������� �������

DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� clients
	client_name VARCHAR(255), -- �������� ����������� �� ������� clients
	contract_id BIGINT UNSIGNED, -- id ��������, � �������� ��������� ������
	contract_name VARCHAR(255), -- ����� �������� �� ������� contracts
	contract_date DATE, -- ���� �������� �� ������� contracts
	legal_address VARCHAR(255), -- ����������� ����� ������� �� ������� client_address
	physical_address VARCHAR(255), -- ����������� ����� ������� �� ������� client_address
	kpp VARCHAR(20), -- ��� ������� �� ������� client_profile
	inn VARCHAR(20),-- ��� ������� �� ������� client_profile
	account_id_group BIGINT UNSIGNED, -- ����������� �� id ������� personal_account, ��� �������� �����
	services_id_group BIGINT UNSIGNED, -- ����������� �� id �������� ������
	monthe_group DATE, -- ����������� �� ������
	sum_cost DOUBLE(20,2), -- ������������ ��������� ��������� ����� �� �����
	sum_nds DOUBLE(20,2), -- ���
	sum_cost_nds DOUBLE(20,2), -- ����� ������� � ������ ���
	invoicing_date DATE, -- ���� ����������� �����
	number_invoice BIGINT UNSIGNED, -- ����� ����� �� ������������ �����
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (account_id_group) REFERENCES personal_account(id)
); -- ������� ������, � ������ ������� �������� ����� ����������� ��������� �� ������� �� ����� � ������� ������

DROP TABLE IF EXISTS payment;
CREATE TABLE payment(
	id SERIAL,
	client_id BIGINT UNSIGNED, -- �������� � id ������� client
	contract_id BIGINT UNSIGNED, -- id ��������, � �������� ��������� ������
	account_id_group BIGINT UNSIGNED, -- ����������� �� id ������� personal_account, ��� �������� �����
	number_invoice BIGINT UNSIGNED, -- ����� ����� �� ������������ �����
	payment_number DATE, -- ����� ���������� ���������
	date_payment DATE, -- ���� �������
	payment_sum DOUBLE(20,2), -- ����� �������
	invoice_sum DOUBLE(20,2), -- ����� �����
	user_id BIGINT UNSIGNED, -- id �� ������� users, ��� �������� ������
	FOREIGN KEY (client_id) REFERENCES clients(id),
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	FOREIGN KEY (account_id_group) REFERENCES personal_account(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
); -- �������, ������������� ������