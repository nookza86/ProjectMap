
CREATE TABLE `members` 
  ( 
     `member_no`          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT, 
     `first_name`         VARCHAR(45) NOT NULL, 
     `last_name`          VARCHAR(45) NOT NULL,
     `email`              VARCHAR(100) NOT NULL, 
     `encrypted_password` VARCHAR(80) NOT NULL, 
     `salt`               VARCHAR(10) NOT NULL, 
     `gender`             VARCHAR(6) NOT NULL, 
     `dob`                DATE NOT NULL, 
     `country`            VARCHAR(50) NOT NULL, 
     `userfrom`           VARCHAR(2) NOT NULL,
     `user_img`           VARCHAR(255) NOT NULL,  
     `last_update`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
     PRIMARY KEY(`member_no`), 
     UNIQUE(`email`) 
  )ENGINE=InnoDB DEFAULT CHARSET=utf8; 

  INSERT INTO `members`(`member_no`, `first_name`, `last_name`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `user_img`) VALUES 
  (1,'nook','we','nook_we@hotmail.com','1Kobq3v8BFD6TDO9ITpQWz8Jt9I5MDQ2YTI3Mzkx','9046a27391','Male','1996-01-07','Thailand','0', 'path/');

CREATE TABLE `attractions` ( 
   `att_no` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT, 
   `att_name` VARCHAR(30) NOT NULL , 
   `descriptions` VARCHAR(500) NOT NULL , 
   `att_img` VARCHAR(255) NOT NULL , 
   `last_update`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
   PRIMARY KEY (`att_no`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `attractions`(`att_no`, `att_name`, `descriptions`) VALUES 
(1,'Bang Pae Waterfall','des'),
(2,'Big Buddaa','des'),
(3,'Chalong Temple','des'),
(4,'Kamala Beach','des'),
(5,'Karon Beach','des'),
(6,'Kata Beach','des'),
(7,'Patong Beach','des');

CREATE TABLE `diary` 
  ( 
     `diary_id`   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT, 
     `member_no`  SMALLINT UNSIGNED NOT NULL, 
     `att_no`     SMALLINT UNSIGNED NOT NULL, 
     `impression` INT(1) NOT NULL,
     `beauty`     INT(1) NOT NULL,
     `clean`      INT(1) NOT NULL,
     `diary_pic1` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic2` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic3` VARCHAR(100)  DEFAULT NULL, 
     `diary_pic4` VARCHAR(100)  DEFAULT NULL, 
     `last_update`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  
     PRIMARY KEY (`diary_id`)/*,
     CONSTRAINT `fk_diary_member_no` FOREIGN KEY (`member_no`) REFERENCES `members`(`member_no`) ON DELETE RESTRICT ON UPDATE CASCADE,
     CONSTRAINT `fk_diary_att_no` FOREIGN KEY (`att_no`) REFERENCES attractions('att_no')*/
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

  
  ALTER TABLE `diary` ADD CONSTRAINT `fk_diary_member_no` FOREIGN KEY (`member_no`) REFERENCES `members`(`member_no`) ON DELETE RESTRICT ON UPDATE CASCADE;
  ALTER TABLE `diary` ADD CONSTRAINT `fk_diary_att_no` FOREIGN KEY (`att_no`) REFERENCES `attractions`(`att_no`) ON DELETE RESTRICT ON UPDATE CASCADE;
  


CREATE TABLE `unattractions` 
  ( 
     `un_id`     SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT, 
     `member_no` SMALLINT UNSIGNED NOT NULL, 
     `att_no`    SMALLINT UNSIGNED NOT NULL, 
     `last_update`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
     PRIMARY KEY (`un_id`)/*,
     CONSTRAINT `fk_diary_member_no` FOREIGN KEY (`member_no`) REFERENCES members('member_no'),
     CONSTRAINT `fk_diary_att_no` FOREIGN KEY (`att_no`) REFERENCES attractions('att_no')*/
    
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `unattractions` ADD CONSTRAINT `fk_unatt_member_no` FOREIGN KEY (`member_no`) REFERENCES `members`(`member_no`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `unattractions` ADD CONSTRAINT `fk_unatt_att_no` FOREIGN KEY (`att_no`) REFERENCES `attractions`(`att_no`) ON DELETE RESTRICT ON UPDATE CASCADE;

  INSERT INTO `unattractions`(`un_id`, `member_no`, `att_no`) VALUES 
(1,1,1);

