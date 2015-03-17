-- phpMyAdmin SQL Dump
-- version 2.6.1-pl3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 01, 2005 at 12:39 PM
-- Server version: 4.0.16
-- PHP Version: 4.3.4
--
-- Database: `xxx`
--

-- --------------------------------------------------------

--
-- Table structure for table `blog_news`
--

CREATE TABLE `blog_news` (
  `id` int(11) NOT NULL auto_increment,
  `data` timestamp(14) NOT NULL,
  `giorno` varchar(10) default 'NULL',
  `titolo` varchar(100) default 'NULL',
  `testo` text,
  `img` varchar(25) default 'NULL',
  `link` varchar(100) default NULL,
  `important` varchar(10) default 'NULL',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_2` (`id`)
) TYPE=MyISAM AUTO_INCREMENT=132 ;
