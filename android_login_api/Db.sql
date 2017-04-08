/*--create database android_api 
 
--use android_api  Selecting Database
--unique_id varchar(23) not null unique,

create table users(
   id int(11) primary key auto_increment, 
   EMPNO varchar(6) NOT NULL default '',
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

CREATE TABLE `members` 
  ( 
     `member_no`          VARCHAR(6) NOT NULL DEFAULT '\'\'', 
     `fname`              VARCHAR(20) NOT NULL, 
     `lname`              VARCHAR(20) NOT NULL, 
     `email`              VARCHAR(30) NOT NULL, 
     `encrypted_password` VARCHAR(80) NOT NULL, 
     `salt`               VARCHAR(10) NOT NULL, 
     `gender`             VARCHAR(6) NOT NULL, 
     `dob`                DATE NOT NULL, 
     `country`            VARCHAR(50) NOT NULL, 
     `userfrom`           VARCHAR(2) NOT NULL, 
     `created_at`         DATETIME NOT NULL, 
     `updated_at`         DATETIME DEFAULT NULL, 
     PRIMARY KEY(`member_no`), 
     UNIQUE(`email`) 
  ) engine = innodb; 

  INSERT INTO `members`(`member_no`, `fname`, `lname`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `created_at`, `updated_at`) VALUES 
  ('000001','nook','we','nook_we@hotmail.com','1Kobq3v8BFD6TDO9ITpQWz8Jt9I5MDQ2YTI3Mzkx','9046a27391','Male','1996-01-07','Thailand','0','Thailand',null);

CREATE TABLE `attractions` ( 
   `att_no` VARCHAR(3) NOT NULL , 
   `att_name` VARCHAR(30) NOT NULL , 
   `descriptions` VARCHAR(500) NOT NULL , 
   `updated_at` DATETIME  DEFAULT NULL , 
   PRIMARY KEY (`att_no`)
) ENGINE = InnoDB;

INSERT INTO `attractions`(`att_no`, `att_name`, `descriptions`, `updated_at`) VALUES 
('001','Bang Pae Waterfall','des',null),
('002','Big Buddaa','des',null),
('003','Chalong Temple','des',null),
('004','Kamala Beach','des',null),
('005','Karon Beach','des',null),
('006','Kata Beach','des',null),
('007','Patong Beach','des',null);

CREATE TABLE `diary` 
  ( 
     `id`         INT(10) NOT NULL auto_increment, 
     `member_no`  VARCHAR(6) NULL DEFAULT NULL, 
     `att_no`     VARCHAR(3) NULL DEFAULT NULL, 
     `impression` INT(1) NOT NULL,
     `beauty`     INT(1) NOT NULL,
     `clean`      INT(1) NOT NULL,
     `diary_pic1` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic2` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic3` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic4` VARCHAR(100)  DEFAULT NULL, 
     PRIMARY KEY (`id`),
     FOREIGN KEY (`member_no`) REFERENCES members(`member_no`),
     FOREIGN KEY (`att_no`) REFERENCES attractions(`att_no`)
  ) 
engine = innodb; 

CREATE TABLE `unattractions` 
  ( 
     `id`        INT(10) NOT NULL auto_increment, 
     `member_no` VARCHAR(6)  DEFAULT NULL, 
     `att_no`    VARCHAR(3)  DEFAULT NULL, 
     `arrive_at` DATETIME NOT NULL,
     PRIMARY KEY (`id`),
     FOREIGN KEY (`member_no`) REFERENCES members(`member_no`),
     FOREIGN KEY (`att_no`) REFERENCES attractions(`att_no`) 
  ) 
engine = innodb; 

