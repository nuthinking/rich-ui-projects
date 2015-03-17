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
-- Table structure for table `cgws_guestbook`
--

CREATE TABLE `cgws_guestbook` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(25) default 'NULL',
  `data` varchar(20) default 'NULL',
  `messaggio` varchar(250) default 'NULL',
  PRIMARY KEY  (`id`),
  KEY `id_2` (`id`)
) TYPE=MyISAM AUTO_INCREMENT=100 ;
