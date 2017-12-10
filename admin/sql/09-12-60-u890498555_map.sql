-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 09, 2017 at 12:11 PM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.0.26

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u890498555_map`
--
CREATE DATABASE IF NOT EXISTS `u890498555_map` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `u890498555_map`;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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

DROP TABLE IF EXISTS `attractions`;
CREATE TABLE `attractions` (
  `att_no` smallint(5) UNSIGNED NOT NULL,
  `att_name` varchar(30) NOT NULL,
  `descriptions` varchar(500) NOT NULL,
  `att_img` varchar(255) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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

DROP TABLE IF EXISTS `diary`;
CREATE TABLE `diary` (
  `diary_id` smallint(5) UNSIGNED NOT NULL,
  `member_no` smallint(5) UNSIGNED NOT NULL,
  `att_no` smallint(5) UNSIGNED NOT NULL,
  `diary_note` varchar(500) DEFAULT NULL,
  `impression` int(1) NOT NULL,
  `beauty` int(1) NOT NULL,
  `clean` int(1) NOT NULL,
  `diary_pic1` varchar(100) DEFAULT NULL,
  `diary_pic2` varchar(100) DEFAULT NULL,
  `diary_pic3` varchar(100) DEFAULT NULL,
  `diary_pic4` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `diary`
--

INSERT INTO `diary` (`diary_id`, `member_no`, `att_no`, `diary_note`, `impression`, `beauty`, `clean`, `diary_pic1`, `diary_pic2`, `diary_pic3`, `diary_pic4`, `last_update`) VALUES
(1, 1, 1, 'แมว', 1, 3, 5, '1_1_1.jpg', '1_1_2.jpg', '1_1_3.jpg', '1_1_4.jpg', '2017-12-09 08:10:29'),
(2, 1, 2, 'Bigบ', 3, 3, 3, '2_1_1.jpg', '2_1_2.jpg', '2_1_3.jpg', '2_1_4.jpg', '2017-11-26 17:56:11'),
(3, 2, 1, 'เช้ามากเลย ยังไม่ค่อยมีคนแต่บรรยากาศดีมากๆ', 5, 4, 1, '1_2_1.jpg', '1_2_2.jpg', '1_2_3.jpg', '1_2_4.jpg', '2017-11-28 03:10:04'),
(4, 2, 7, 'ป่าตอง ไปมาแล้ววว', 3, 4, 5, '7_2_1.jpg', '7_2_2.jpg', '7_2_3.jpg', '7_2_4.jpg', '2017-11-28 04:49:08'),
(5, 5, 7, 'อากาศดีมากๆ ไม่มีแดดเลย ', 4, 4, 1, '7_5_1.jpg', '', '', '', '2017-11-28 04:51:17'),
(6, 2, 4, 'ชาวต่างชาติเยอะ แต่เค้าพูดอังกฤษไม่ได้ อากาศเย็นๆร่มรื่นดี', 4, 4, 5, '4_2_1.jpg', '4_2_2.jpg', '4_2_3.jpg', '', '2017-11-28 04:55:14'),
(7, 2, 5, 'หาดกะรนร่มรื่นดีมาก บรรยากาศดี ไม่ร้อนเลย ', 4, 0, 5, '5_2_1.jpg', '5_2_2.jpg', '5_2_3.jpg', '5_2_4.jpg', '2017-11-28 05:29:10'),
(8, 5, 5, 'ลมเย็นสบายมาก ดูเหมือนคนเยอะ แต่ก็เงียบสงบดี ', 3, 4, 4, '5_5_1.jpg', '5_5_2.jpg', '5_5_3.jpg', '5_5_4.jpg', '2017-11-28 05:29:48'),
(9, 2, 6, 'หาดกะตะ คนเยอะดี แต่บรรยากาศเงียบๆ สบายดี', 5, 4, 4, '6_2_1.jpg', '6_2_2.jpg', '6_2_3.jpg', '6_2_4.jpg', '2017-11-28 05:47:43'),
(10, 2, 3, 'ไหว้พระทำบุญวัดฉลอง', 4, 3, 1, '3_2_1.jpg', '3_2_2.jpg', '3_2_3.jpg', '3_2_4.jpg', '2017-11-28 08:50:27'),
(11, 5, 1, 'ไปตอนเช้า ไม่มีคนเลย อากาศเย็น เงียบสงบดี มีเสียงชะนีต้อนรับด้วย ', 5, 4, 4, '1_5_1.jpg', '1_5_2.jpg', '', '', '2017-11-29 01:47:22');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
  `member_no` smallint(5) UNSIGNED NOT NULL,
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
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_no`, `first_name`, `last_name`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `uniqid`, `active`, `user_img`, `last_update`) VALUES
(1, 'Krittanan', 'Hokhuadsim', 'nook_we@hotmail.com', 'gkwS23mrXwl3H/aXEp79jg3ut7o0ZmUxOTUwZTNk', '4fe1950e3d', 'Male', '1996-01-07', 'Thailand', '0', '59190c173ec008.39005804', 'Yes', '1.jpg', '2017-11-29 07:49:41'),
(2, 'korakot', 'jiyapetch', 'cnviisz@gmail.com', 's31/jdS84KUMjZMLkUHOE05azncwMDMyNmI2Yzkz', '00326b6c93', 'Female', '1995-09-04', 'Argentina', '0', '5a1bc91d2fb126.50587221', 'Yes', '2.jpg', '2017-11-27 08:27:47'),
(3, 'supapon', 'Raksaphon', 'prae1125@gmail.com', 'g8X0pWMLzvFi6cIn6NBLBunsco80MGE4ZDRiOTY2', '40a8d4b966', 'Female', '1995-11-25', 'Australia', '0', '5a1bc9ea7b7972.49667802', 'Yes', '3.jpg', '2017-11-27 08:30:09'),
(5, 'Praeploy', 'Khunmouk', 'praeploy_km@hotmail.com', 'vXkPju5QjM4ThBKpAE4tjMM4m1s5MjE5ZmQ1NGFh', '9219fd54aa', 'Female', '1995-08-09', 'Thailand', '0', '5a1cb7159523f7.48081611', 'Yes', '5.jpg', '2017-11-28 01:19:27'),
(6, 'jessada', 'sonyod', 'jessada17044@gmail.com', 'K2sJUDr+kBh5YgEH2cvbYpEqNmI3NjkyZDdjYzI5', '7692d7cc29', 'Male', '1996-10-14', 'Thailand', '0', '5a1ce687bb5a32.18743952', 'Yes', '6.jpg', '2017-11-28 04:54:40');

-- --------------------------------------------------------

--
-- Table structure for table `unattractions`
--

DROP TABLE IF EXISTS `unattractions`;
CREATE TABLE `unattractions` (
  `un_id` smallint(5) UNSIGNED NOT NULL,
  `member_no` smallint(5) UNSIGNED NOT NULL,
  `att_no` smallint(5) UNSIGNED NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `unattractions`
--

INSERT INTO `unattractions` (`un_id`, `member_no`, `att_no`, `latitude`, `longitude`, `last_update`) VALUES
(1, 1, 1, 8.04132, 98.3934, '2017-04-09 18:37:53'),
(2, 1, 2, 7.82752, 98.3127, '2017-11-22 06:45:34'),
(3, 5, 1, 8.04156, 98.3939, '2017-11-28 02:27:08'),
(4, 2, 1, 8.04168, 98.3939, '2017-11-28 03:03:12'),
(5, 3, 1, 8.04172, 98.3939, '2017-11-28 03:05:51'),
(6, 5, 4, 7.95394, 98.2826, '2017-11-28 03:45:21'),
(7, 2, 4, 7.95323, 98.2823, '2017-11-28 04:05:44'),
(8, 5, 7, 7.89063, 98.2934, '2017-11-28 04:42:27'),
(9, 3, 7, 7.89089, 98.2937, '2017-11-28 04:42:48'),
(10, 2, 7, 7.89073, 98.2937, '2017-11-28 04:45:02'),
(11, 3, 5, 7.84353, 98.2944, '2017-11-28 05:24:24'),
(12, 2, 5, 7.84342, 98.2941, '2017-11-28 05:27:39'),
(13, 5, 5, 7.84372, 98.2946, '2017-11-28 05:27:53'),
(14, 2, 6, 7.82368, 98.2959, '2017-11-28 05:46:14'),
(15, 5, 6, 7.82258, 98.296, '2017-11-28 05:47:07'),
(16, 3, 6, 7.82321, 98.2966, '2017-11-28 05:47:16'),
(17, 2, 2, 7.82772, 98.3133, '2017-11-28 07:14:28'),
(18, 5, 2, 7.82762, 98.3131, '2017-11-28 07:15:04'),
(19, 3, 2, 7.82771, 98.3122, '2017-11-28 07:24:09'),
(20, 5, 3, 7.84681, 98.3365, '2017-11-28 08:02:06'),
(21, 3, 3, 7.8466, 98.3368, '2017-11-28 08:02:37'),
(22, 2, 3, 7.84683, 98.3365, '2017-11-28 08:25:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attractions`
--
ALTER TABLE `attractions`
  ADD PRIMARY KEY (`att_no`);

--
-- Indexes for table `diary`
--
ALTER TABLE `diary`
  ADD PRIMARY KEY (`diary_id`),
  ADD KEY `member_no` (`member_no`),
  ADD KEY `att_no` (`att_no`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`member_no`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `unattractions`
--
ALTER TABLE `unattractions`
  ADD PRIMARY KEY (`un_id`),
  ADD KEY `member_no` (`member_no`),
  ADD KEY `att_no` (`att_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `attractions`
--
ALTER TABLE `attractions`
  MODIFY `att_no` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `diary`
--
ALTER TABLE `diary`
  MODIFY `diary_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `member_no` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `unattractions`
--
ALTER TABLE `unattractions`
  MODIFY `un_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
