/*
 * Создание БД для ВКонтакте
 */
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	firstname VARCHAR(100),
	lastname VARCHAR(100),
	email VARCHAR(120) UNIQUE,
	password_hash VARCHAR(120),
	phone BIGINT UNSIGNED UNIQUE,
	INDEX users_firstname_lastname_idx(firstname, lastname) 
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
	gender CHAR(1),
	birthday DATE,
	hometown VARCHAR(50),
	photo_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
	
	# my lines:
	
	residence_place VARCHAR(255),	
	school VARCHAR(100),
	univercity VARCHAR(255),
	education VARCHAR(30),
	work_place VARCHAR(255),
	interest VARCHAR(255),
	favorite_quotes VARCHAR(255),
	favorite_books VARCHAR(255),
	favorite_music VARCHAR(255),
	favorite_moves VARCHAR(255)
);

ALTER TABLE profiles ADD CONSTRAINT fk_user_id
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE
	ON DELETE RESTRICT;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
# SERIAL = UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);


# my lines:

DROP TABLE IF EXISTS friends;
CREATE TABLE friends(
	id SERIAL,
	id_user_master BIGINT UNSIGNED NOT NULL, -- у кого был запрос на дружбу
	id_user_slave BIGINT UNSIGNED NOT NULL, -- запрашивающий пользователь
	friend_status ENUM('requested', 'comfirmed', 'rejected', 'blocked'), -- /запрос/подтвержение/отклонение/блокировка
	data_requested DATETIME DEFAULT NOW(),
	FOREIGN KEY (id_user_master) REFERENCES users(id),
	FOREIGN KEY (id_user_slave) REFERENCES users(id)
);

# таблица содержащая информацию по видео, фото, медиа
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL, 
	user_id BIGINT UNSIGNED NOT NULL, -- кто добавил
	media_path VARCHAR(255), -- путь к файлу
	data_add DATETIME DEFAULT NOW(), -- дата создания
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	post_title VARCHAR(255),
	post_text TEXT,
	post_data DATETIME DEFAULT NOW(),
	media_input BIGINT UNSIGNED, -- добавление в пост фото, видео, музыки, задается программно (media_id)
	FOREIGN KEY (user_id) REFERENCES users(id)	
);

DROP TABLE IF EXISTS groups_add;
CREATE TABLE groups_add(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	admin_id BIGINT UNSIGNED NOT NULL,
	post_id BIGINT UNSIGNED NOT NULL, -- добавляются программо
	media_id BIGINT UNSIGNED NOT NULL, -- добавляются программно
	group_name VARCHAR(255),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (admin_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id),
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL, -- кто поставил лайк
	media_id BIGINT UNSIGNED NOT NULL, -- что было лайкнуто. Задается программно (messages_id or media_id or post_id ...)
	data_of_liked DATETIME DEFAULT NOW(), -- когда
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);