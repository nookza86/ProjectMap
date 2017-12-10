
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 05, 2017 at 10:47 AM
-- Server version: 10.1.22-MariaDB
-- PHP Version: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `u890498555_map`
--

-- --------------------------------------------------------

--
-- Table structure for table `members`
--
-- Creation: Dec 05, 2017 at 10:46 AM
-- Last update: Dec 05, 2017 at 10:46 AM
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE IF NOT EXISTS `members` (
  `member_no` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email` varchar(100) NOT NULL,
  `encrypted_password` varchar(80) NOT NULL,
  `salt` varchar(10) NOT NULL,
  `gender` varchar(6) NOT NULL,
  `dob` date NOT NULL,
  `country` varchar(50) NOT NULL,
  `userfrom` varchar(2) NOT NULL,
  `uniqid` varchar(100) NOT NULL,
  `active` varchar(3) NOT NULL DEFAULT 'no',
  `user_img` varchar(255) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_no`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_no`, `first_name`, `last_name`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `uniqid`, `active`, `user_img`, `last_update`) VALUES
(1, 'Krittanan', 'Hokhuadsim', 'nook_we@hotmail.com', 'gkwS23mrXwl3H/aXEp79jg3ut7o0ZmUxOTUwZTNk', '4fe1950e3d', 'Male', '1996-01-07', 'Thailand', '0', '59190c173ec008.39005804', 'Yes', '1.jpg', '2017-11-29 07:49:41'),
(2, 'korakot', 'jiyapetch', 'cnviisz@gmail.com', 's31/jdS84KUMjZMLkUHOE05azncwMDMyNmI2Yzkz', '00326b6c93', 'Female', '1995-09-04', 'Argentina', '0', '5a1bc91d2fb126.50587221', 'Yes', '2.jpg', '2017-11-27 08:27:47'),
(3, 'supapon', 'Raksaphon', 'prae1125@gmail.com', 'g8X0pWMLzvFi6cIn6NBLBunsco80MGE4ZDRiOTY2', '40a8d4b966', 'Female', '1995-11-25', 'Australia', '0', '5a1bc9ea7b7972.49667802', 'Yes', '3.jpg', '2017-11-27 08:30:09'),
(4, 'a', 'b', 'test@mapp.com', '9TtjAw4vqGH+F0iczDwTCd6YLXMzYmU2ZWY1ZTIz', '3be6ef5e23', 'Male', '1991-05-18', 'Australia', '0', '5a1cae66ceff36.02481787', 'Yes', '4.jpg', '2017-11-28 00:41:26'),
(5, 'Praeploy', 'Khunmouk', 'praeploy_km@hotmail.com', 'vXkPju5QjM4ThBKpAE4tjMM4m1s5MjE5ZmQ1NGFh', '9219fd54aa', 'Female', '1995-08-09', 'Thailand', '0', '5a1cb7159523f7.48081611', 'Yes', '5.jpg', '2017-11-28 01:19:27'),
(6, 'jessada', 'sonyod', 'jessada17044@gmail.com', 'K2sJUDr+kBh5YgEH2cvbYpEqNmI3NjkyZDdjYzI5', '7692d7cc29', 'Male', '1996-10-14', 'Thailand', '0', '5a1ce687bb5a32.18743952', 'Yes', '6.jpg', '2017-11-28 04:54:40');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
