--create database android_api /** Creating Database **/
 
--use android_api /** Selecting Database **/
--unique_id varchar(23) not null unique,

create table users(
   id int(11) primary key auto_increment, 
   fname varchar(50) not null,
   lname varchar(50) not null,
   email varchar(100) not null unique,
   encrypted_password varchar(80) not null,
   salt varchar(10) not null,
   gender varchar(6) not null,
   dob date not null,
   country varchar(50) not null,
   userfrom char(1) not null,
   created_at datetime,
   updated_at datetime null
); /** Creating Users Table **/