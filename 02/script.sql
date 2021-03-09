drop database if exists example;
create database example;

use example;

drop table if exists users;
create table users (
	id int(8) not null,
	name char(255)
);