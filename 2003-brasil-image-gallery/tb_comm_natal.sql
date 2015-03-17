-- phpMyAdmin SQL Dump
-- version 2.6.1-pl3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 01, 2005 at 12:40 PM
-- Server version: 4.0.16
-- PHP Version: 4.3.4
--
-- Database: `xxx`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_comm_natal`
--

CREATE TABLE `tb_comm_natal` (
  `id` int(11) NOT NULL auto_increment,
  `ref` varchar(20) default NULL,
  `nome` varchar(50) default NULL,
  `commento` text,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM AUTO_INCREMENT=68 ;
