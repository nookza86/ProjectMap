-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 15, 2017 at 09:57 AM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.6.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mapofmemdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'nook', '095863270');

-- --------------------------------------------------------

--
-- Table structure for table `attractions`
--

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
(1, 'Bang Pae Waterfall', 'des', 'uploads/attractions/Bang Pae Waterfall/favicon.png', '2017-04-14 15:06:54'),
(2, 'Big Buddaa', 'des', '', '2017-04-14 06:48:29'),
(3, 'Chalong Temple', 'des', '', '2017-04-10 08:37:53'),
(4, 'Kamala Beach', 'des', '', '2017-04-10 08:37:53'),
(5, 'Karon Beach', 'des', '', '2017-04-10 08:37:53'),
(6, 'Kata Beach', 'des', '', '2017-04-10 08:37:53'),
(7, 'Patong Beach', 'des', '', '2017-04-10 08:37:53');

-- --------------------------------------------------------

--
-- Table structure for table `diary`
--

CREATE TABLE `diary` (
  `diary_id` smallint(5) UNSIGNED NOT NULL,
  `member_no` smallint(5) UNSIGNED NOT NULL,
  `att_no` smallint(5) UNSIGNED NOT NULL,
  `impression` int(1) NOT NULL,
  `beauty` int(1) NOT NULL,
  `clean` int(1) NOT NULL,
  `diary_pic1` varchar(100) DEFAULT NULL,
  `diary_pic2` varchar(100) DEFAULT NULL,
  `diary_pic3` varchar(100) DEFAULT NULL,
  `diary_pic4` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

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
  `user_img` varchar(255) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_no`, `first_name`, `last_name`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, `user_img`, `last_update`) VALUES
(1, 'nook', 'wee', 'nook_we@hotmail.com', '1Kobq3v8BFD6TDO9ITpQWz8Jt9I5MDQ2YTI3Mzkx', '9046a27391', 'Male', '1996-01-07', 'Thailand', '0', 'path/', '2017-04-12 06:41:30'),
(2, 'qq', 'qq', 'qq@dd.cc', '0V9pS1LPgTV8HZYAp+BkTewRcY43NzIzODViZTNi', '772385be3b', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 09:01:03'),
(3, 'qwe', 'qwe', 'qwe@ee.cc', 'Qy0AY4wIgbyPJT8Dpr+Xm7rlDi8yMjZmM2UyMTI4', '226f3e2128', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 09:10:29'),
(4, 'cccc', 'cc', 'cc@cc.cc', 'OClRM5dxwPU2yiWsQKQt21z/cD5kY2NhNzkzYThk', 'dcca793a8d', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 10:33:05'),
(5, 'cccc', 'cc', 'cccc@cc.cc', 'Kef4Y9uPJuXcpHXxe6ZdkK71wME4ZDcxZmU3ZTgy', '8d71fe7e82', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 10:34:27'),
(6, 'cccc', 'cc', 'ccccc@cc.cc', 'IcPJLIzUkFIYL1k6/AAEWpbLr01mYmY5ZmNmYzQ1', 'fbf9fcfc45', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 10:36:08'),
(7, 'cccc', 'cc', 'cccccc@cc.cc', 'InrBm8wHwyCy+BgQDopORLsDHEBmNjM0ZjViNGNj', 'f634f5b4cc', 'Male', '1991-05-18', 'Bolivia', '0', '/img_path/user.jpg', '2017-04-10 10:37:54');

-- --------------------------------------------------------

--
-- Table structure for table `unattractions`
--

CREATE TABLE `unattractions` (
  `un_id` smallint(5) UNSIGNED NOT NULL,
  `member_no` smallint(5) UNSIGNED NOT NULL,
  `att_no` smallint(5) UNSIGNED NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `unattractions`
--

INSERT INTO `unattractions` (`un_id`, `member_no`, `att_no`, `last_update`) VALUES
(1, 1, 1, '2017-04-10 08:37:53');

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
  ADD KEY `fk_diary_member_no` (`member_no`),
  ADD KEY `fk_diary_att_no` (`att_no`);

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
  ADD KEY `fk_unatt_member_no` (`member_no`),
  ADD KEY `fk_unatt_att_no` (`att_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `attractions`
--
ALTER TABLE `attractions`
  MODIFY `att_no` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `diary`
--
ALTER TABLE `diary`
  MODIFY `diary_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `member_no` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `unattractions`
--
ALTER TABLE `unattractions`
  MODIFY `un_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
