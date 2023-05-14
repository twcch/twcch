-- MySQL dump 10.13  Distrib 8.0.20, for macos10.15 (x86_64)
--
-- Host: localhost    Database: bookshop
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `isbn` char(13) NOT NULL,
  `book_name` varchar(200) NOT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `author` varchar(200) DEFAULT NULL,
  `publication_date` date DEFAULT NULL,
  `publisher_id` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`isbn`),
  KEY `fk_book_publisher` (`publisher_id`),
  CONSTRAINT `fk_book_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('9780071751292','Oracle Database 11g',1139.00,'Jinyu Wang','2011-09-14','P005'),('9780134543666','Starting Out with Python',5451.00,'Tony Gaddis','2017-06-15','P006'),('9780596009205','Head First Java',1186.00,'Kathy Sierra and Bert Bates','2005-02-19','P001'),('9780596809157','R Cookbook',935.00,'Paul Teetor','2016-03-01','P001'),('9781118407813','Beginning Programming with Java For Dummies',550.00,'Barry Burd','2014-07-11','P002'),('9781119017929','Android App Development for Dummies, 3rd Edition',560.00,'Donn Felker','2015-03-09','P002'),('9781259587405','Programming the Raspberry Pi',550.00,'Simon Monk','2015-10-05','P005'),('9781430237174','Pro IOS Apps Performance Optimization',1151.00,'Khang Vo','2011-11-16','P004'),('9781484226766','Python Unit Test Automation',731.00,'Ashwin Pajankar','2017-06-12','P004'),('9781491936696','iOS 9 Swift Programming Cookbook',1443.00,'Vandad Nahavandipoor','2016-01-08','P001'),('9781617291999','Java 8 in Action',936.00,'Raoul-gabriel Urma, Mario Fusco, Alan Mycroft','2014-08-28','P003'),('9783527711499','Android App Entwicklung fur Dummies',845.00,'Donn Felker','2016-12-01','P002'),('9789352133468','25 Recipes for Getting Started with R',303.00,'Paul Teetor','2016-08-01','P001');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` varchar(40) NOT NULL,
  `customer_name` varchar(40) NOT NULL,
  `phone` varchar(40) NOT NULL,
  `address` varchar(200) NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('C001','Jack','02-23456789','No. 3, Ln. 39, Sec. 2 Zhongshan N. Rd., Taipei 104, Taiwan'),('C002','Sue','02-25671234','No. 1, Zhongzheng Road, Taoyuan District, Taoyuan City, Taiwan 330'),('C003','Jason','03-3556355','No. 1, Section 1, Taiwan Boulevard, Central District, Taichung City, Taiwan 400');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_id` bigint unsigned NOT NULL,
  `isbn` char(13) NOT NULL,
  `quantity` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`order_id`,`isbn`),
  KEY `fk_order_detail_book` (`isbn`),
  CONSTRAINT `fk_order_detail_book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`),
  CONSTRAINT `fk_order_detail_order_master` FOREIGN KEY (`order_id`) REFERENCES `order_master` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,'9780596009205',2),(1,'9780596809157',1),(2,'9780596009205',1),(2,'9780596809157',3),(2,'9781484226766',2),(3,'9780596009205',1),(3,'9780596809157',1),(3,'9781484226766',1);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_master`
--

DROP TABLE IF EXISTS `order_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_master` (
  `order_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(40) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `fk_order_master_customer` (`customer_id`),
  CONSTRAINT `fk_order_master_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_master`
--

LOCK TABLES `order_master` WRITE;
/*!40000 ALTER TABLE `order_master` DISABLE KEYS */;
INSERT INTO `order_master` VALUES (1,'C001','2019-03-01 15:00:00'),(2,'C002','2019-06-01 09:00:00'),(3,'C001','2019-06-30 12:00:00');
/*!40000 ALTER TABLE `order_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `publisher_id` varchar(40) NOT NULL,
  `publisher_name` varchar(40) NOT NULL,
  `contact` varchar(40) DEFAULT NULL,
  `phone` varchar(40) NOT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES ('P001','O\'Reilly','Ocean','02-23456789','2019-06-28 11:21:55'),('P002','John Wiley, Sons Inc','Don','03-36962869','2019-06-28 11:21:55'),('P003','Manning Publications','Mary','04-43456789','2019-06-28 11:21:55'),('P004','Apress','Allen','05-59876543','2019-06-28 11:21:55'),('P005','McGraw-Hill','Mike','06-69876543','2019-06-28 11:21:55'),('P006','Pearson','Paul','09-98767867','2019-06-28 11:21:55'),('P00X','Publisher X','X-Man','07-75698765','2019-06-28 11:21:55'),('P00Y','Publisher Y','Yale','08-83698765','2019-06-28 11:21:55');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase`
--

DROP TABLE IF EXISTS `purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase` (
  `purchase_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `isbn` char(13) NOT NULL,
  `quantity` decimal(2,0) NOT NULL,
  `purchase_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`purchase_id`),
  KEY `fk_purchase_book` (`isbn`),
  CONSTRAINT `fk_purchase_book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase`
--

LOCK TABLES `purchase` WRITE;
/*!40000 ALTER TABLE `purchase` DISABLE KEYS */;
INSERT INTO `purchase` VALUES (1,'9780596009205',20,'2019-06-28 11:22:51'),(2,'9780596809157',10,'2019-06-28 11:22:51'),(3,'9781491936696',10,'2019-06-28 11:22:51'),(4,'9781118407813',40,'2019-06-28 11:22:51'),(5,'9781617291999',30,'2019-06-28 11:22:51'),(6,'9781430237174',50,'2019-06-28 11:22:51'),(7,'9781484226766',20,'2019-06-28 11:22:51'),(8,'9780071751292',30,'2019-06-28 11:22:51'),(9,'9781259587405',60,'2019-06-28 11:22:51'),(10,'9780134543666',70,'2019-06-28 11:22:51'),(11,'9781119017929',80,'2019-06-28 11:22:51'),(12,'9783527711499',40,'2019-06-28 11:22:51'),(13,'9789352133468',60,'2019-06-28 11:22:51'),(14,'9780596009205',80,'2019-06-28 11:22:51'),(15,'9780596809157',40,'2019-06-28 11:22:51'),(16,'9781491936696',20,'2019-06-28 11:22:51'),(17,'9781118407813',50,'2019-06-28 11:22:51'),(18,'9781617291999',20,'2019-06-28 11:22:51'),(19,'9781430237174',70,'2019-06-28 11:22:51'),(20,'9781484226766',90,'2019-06-28 11:22:51'),(21,'9780071751292',30,'2019-06-28 11:22:51'),(22,'9781259587405',60,'2019-06-28 11:22:51'),(23,'9780134543666',40,'2019-06-28 11:22:51'),(24,'9781119017929',10,'2019-06-28 11:22:51'),(25,'9783527711499',40,'2019-06-28 11:22:51'),(26,'9789352133468',20,'2019-06-28 11:22:51');
/*!40000 ALTER TABLE `purchase` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-10 22:35:12
