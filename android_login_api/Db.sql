
CREATE TABLE `members` 
  ( 
     `id`                 INT(10) NOT NULL auto_increment,
     `member_no`          VARCHAR(6) NOT NULL, 
     `fname`              VARCHAR(20) NOT NULL, 
     `lname`              VARCHAR(20) NOT NULL, 
     `email`              VARCHAR(30) NOT NULL, 
     `encrypted_password` VARCHAR(80) NOT NULL, 
     `salt`               VARCHAR(10) NOT NULL, 
     `gender`             VARCHAR(6) NOT NULL, 
     `dob`                DATE NOT NULL, 
     `country`            VARCHAR(50) NOT NULL, 
     `userfrom`           VARCHAR(2) NOT NULL,
     `user_img`           VARCHAR(255) NOT NULL,  
     `created_at`         DATETIME DEFAULT NULL, 
     `updated_at`         DATETIME DEFAULT NULL, 
     PRIMARY KEY(`id`), 
     UNIQUE(`email`) 
  ) ; 

  INSERT INTO `members`(`member_no`, `fname`, `lname`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `user_img`, `created_at`, `updated_at`) VALUES 
  ('000001','nook','we','nook_we@hotmail.com','1Kobq3v8BFD6TDO9ITpQWz8Jt9I5MDQ2YTI3Mzkx','9046a27391','Male','1996-01-07','Thailand','0', 'path/','2017-04-04 14:45:06',null);

CREATE TABLE `attractions` ( 
   `id` INT(10) NOT NULL auto_increment,
   `att_no` VARCHAR(3) NOT NULL , 
   `att_name` VARCHAR(30) NOT NULL , 
   `descriptions` VARCHAR(500) NOT NULL , 
   `att_img` VARCHAR(255) NOT NULL ,
   `created_at` DATETIME DEFAULT NULL, 
   `updated_at` DATETIME  DEFAULT NULL , 
   PRIMARY KEY (`id`)
) ;

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
     `created_at`         DATETIME DEFAULT NULL, 
     `updated_at`         DATETIME DEFAULT NULL, 
     PRIMARY KEY (`id`)
   
  ) ;


CREATE TABLE `unattractions` 
  ( 
     `id`        INT(10) NOT NULL auto_increment, 
     `member_no` VARCHAR(6)  DEFAULT NULL, 
     `att_no`    VARCHAR(3)  DEFAULT NULL, 
     `arrive_at` DATETIME DEFAULT NULL,
     `created_at`         DATETIME DEFAULT NULL, 
     `updated_at`         DATETIME DEFAULT NULL,
     PRIMARY KEY (`id`)
    
  ) ;

