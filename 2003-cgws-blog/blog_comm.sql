-- phpMyAdmin SQL Dump
-- version 2.6.1-pl3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 01, 2005 at 12:38 PM
-- Server version: 4.0.16
-- PHP Version: 4.3.4
--
-- Database: `xxx`
--

-- --------------------------------------------------------

--
-- Table structure for table `blog_comm`
--

CREATE TABLE `blog_comm` (
  `id` int(11) NOT NULL auto_increment,
  `ref` varchar(11) default 'NULL',
  `time` varchar(30) default 'NULL',
  `testo` text,
  `nome` varchar(50) default 'NULL',
  `email` varchar(50) default 'NULL',
  `site` varchar(50) default 'NULL',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_2` (`id`)
) TYPE=MyISAM AUTO_INCREMENT=88 ;
