
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 27, 2017 at 07:23 AM
-- Server version: 10.1.22-MariaDB
-- PHP Version: 5.2.17

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT=0;
START TRANSACTION;
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
-- Table structure for table `admin`
--
-- Creation: Jun 01, 2017 at 09:23 AM
-- Last update: Jun 01, 2017 at 09:23 AM
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'nook_we@hotmail.com', '095863270'),
(2, 'cnviisz@gmail.com', '0827303767'),
(3, 'prae1125@gmail.com', '0836390932');

-- --------------------------------------------------------

--
-- Table structure for table `attractions`
--
-- Creation: Jun 01, 2017 at 09:23 AM
-- Last update: Jun 01, 2017 at 11:51 AM
--

DROP TABLE IF EXISTS `attractions`;
CREATE TABLE IF NOT EXISTS `attractions` (
  `att_no` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `att_name` varchar(30) NOT NULL,
  `descriptions` varchar(500) NOT NULL,
  `att_img` varchar(255) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`att_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `attractions`
--

INSERT INTO `attractions` (`att_no`, `att_name`, `descriptions`, `att_img`, `last_update`) VALUES
(1, 'Bang Pae Waterfall', 'There is a relatively small waterfall and cool refuge with various species of tree. The waterfall is also home to Gibbon Rehabilitation Center. There is smaller than Ton Sai Waterfall and has a lot of rock which beside brook. There are troughs for bathing. It pours a great volume of water in all season.', 'uploads/attractions/Bang Pae Waterfall/favicon.png', '2017-04-14 01:06:54'),
(2, 'Big Buddha', 'Phuket is Big Buddha is one of the island is most important and revered landmarks on the island. The huge image sits on top of the Nakkerd Hills between Chalong and Kata and, at 45 metres tall, it is easily seen from far away. The lofty site offers the best 360-degree views of the island.', '', '2017-04-13 16:48:29'),
(3, 'Chalong Temple', 'Chalong Temple, It is a religious place in Phuket. A temple with a long history and the most beautiful in Phuket. This temple is famous for its sacred Luang Por Cham. The reputation of Luang Por Cham further to neighboring countries like Penang Malaysia.', '', '2017-04-09 18:37:53'),
(4, 'Kamala Beach', 'Kamala Beach is very quiet and located in the South of Surin Beach. Grain of sand is not fine. The beach is approximately 2 km longs. There is a tsunami monument that is a reminder of the tsunami and the terrible damage it inflicted.', '', '2017-04-09 18:37:53'),
(5, 'Karon Beach', 'Karon Beach is one of Phuket’s longest beaches and located near The North of Kata Beach. Karon Beach is split from Kata Beach by a small hill. Larch trees and sugar palm trees fringe the beach. There are strong wave and wind, therefore this is not a favorite tourist beach for bathing but suitable for sunbathing and strolling. ', '', '2017-04-09 18:37:53'),
(6, 'Kata Beach', 'Kata Beach is located between Kata Noi and Karon Beaches. Kata beach is a popular beach on Phuket Island. The beach has soft white sand and palm trees fringe. Large number of tourists choose to stay in Kata beach as it is quite and more peaceful than the other beaches.', '', '2017-04-09 18:37:53'),
(7, 'Patong Beach', 'Patong Beach is the most popular tourists place in Phuket Island. Patong beach is an absolutely perfect bathing beach with fine white sand. There also have a lot of water activities such as Jet Ski, speed boat, parasailing, banana boat, windsurfing, wakeboard. Patong Beach is a heaven for most tourists.', '', '2017-04-09 18:37:53');

-- --------------------------------------------------------

--
-- Table structure for table `diary`
--
-- Creation: Jun 01, 2017 at 11:42 AM
-- Last update: Nov 26, 2017 at 05:56 PM
--

DROP TABLE IF EXISTS `diary`;
CREATE TABLE IF NOT EXISTS `diary` (
  `diary_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `member_no` smallint(5) unsigned NOT NULL,
  `att_no` smallint(5) unsigned NOT NULL,
  `diary_note` varchar(500) DEFAULT NULL,
  `impression` int(1) NOT NULL,
  `beauty` int(1) NOT NULL,
  `clean` int(1) NOT NULL,
  `diary_pic1` varchar(100) DEFAULT NULL,
  `diary_pic2` varchar(100) DEFAULT NULL,
  `diary_pic3` varchar(100) DEFAULT NULL,
  `diary_pic4` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`diary_id`),
  KEY `member_no` (`member_no`),
  KEY `att_no` (`att_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `diary`
--
-- --------------------------------------------------------

--
-- Table structure for table `members`
--
-- Creation: Jun 01, 2017 at 09:23 AM
-- Last update: Nov 24, 2017 at 09:39 AM
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `members`
--


-- --------------------------------------------------------

--
-- Table structure for table `unattractions`
--
-- Creation: Nov 12, 2017 at 08:33 AM
-- Last update: Nov 27, 2017 at 07:21 AM
--

DROP TABLE IF EXISTS `unattractions`;
CREATE TABLE IF NOT EXISTS `unattractions` (
  `un_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `member_no` smallint(5) unsigned NOT NULL,
  `att_no` smallint(5) unsigned NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`un_id`),
  KEY `member_no` (`member_no`),
  KEY `att_no` (`att_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `unattractions`
--


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
