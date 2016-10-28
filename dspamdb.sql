-- MySQL dump 10.13  Distrib 5.1.71, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: dspam
-- ------------------------------------------------------
-- Server version	5.1.71

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dspam_preferences`
--

DROP TABLE IF EXISTS `dspam_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dspam_preferences` (
  `uid` int(10) unsigned NOT NULL,
  `preference` varchar(32) COLLATE latin1_general_ci NOT NULL,
  `value` varchar(64) COLLATE latin1_general_ci NOT NULL,
  UNIQUE KEY `id_preferences_01` (`uid`,`preference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dspam_signature_data`
--

DROP TABLE IF EXISTS `dspam_signature_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dspam_signature_data` (
  `uid` int(10) unsigned NOT NULL,
  `signature` char(32) COLLATE latin1_general_ci NOT NULL,
  `data` longblob NOT NULL,
  `length` int(10) unsigned NOT NULL,
  `created_on` date NOT NULL,
  UNIQUE KEY `id_signature_data_01` (`uid`,`signature`),
  KEY `id_signature_data_02` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci MAX_ROWS=2500000 AVG_ROW_LENGTH=8096;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dspam_stats`
--

DROP TABLE IF EXISTS `dspam_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dspam_stats` (
  `uid` int(10) unsigned NOT NULL,
  `spam_learned` bigint(20) unsigned NOT NULL,
  `innocent_learned` bigint(20) unsigned NOT NULL,
  `spam_misclassified` bigint(20) unsigned NOT NULL,
  `innocent_misclassified` bigint(20) unsigned NOT NULL,
  `spam_corpusfed` bigint(20) unsigned NOT NULL,
  `innocent_corpusfed` bigint(20) unsigned NOT NULL,
  `spam_classified` bigint(20) unsigned NOT NULL,
  `innocent_classified` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dspam_token_data`
--

DROP TABLE IF EXISTS `dspam_token_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dspam_token_data` (
  `uid` int(10) unsigned NOT NULL,
  `token` bigint(20) unsigned NOT NULL,
  `spam_hits` bigint(20) unsigned NOT NULL,
  `innocent_hits` bigint(20) unsigned NOT NULL,
  `last_hit` date NOT NULL,
  UNIQUE KEY `id_token_data_01` (`uid`,`token`),
  KEY `spam_hits` (`spam_hits`),
  KEY `innocent_hits` (`innocent_hits`),
  KEY `last_hit` (`last_hit`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PACK_KEYS=1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dspam_virtual_uids`
--

DROP TABLE IF EXISTS `dspam_virtual_uids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dspam_virtual_uids` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `id_virtual_uids_01` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-29 10:00:12
