-- --------------------------------------------------------
-- Host:                         194.59.206.15
-- Server version:               10.11.4-MariaDB-1~deb12u1 - Debian 12
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for automaat
CREATE DATABASE IF NOT EXISTS `automaat` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `automaat`;

-- Dumping structure for table automaat.car
CREATE TABLE IF NOT EXISTS `car` (
  `licensePlate` varchar(255) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `fuel` enum('GASOLINE','DIESEL','HYBRID','ELECTRIC') DEFAULT NULL,
  `options` varchar(255) DEFAULT NULL,
  `engineSize` int(11) DEFAULT NULL,
  `modelYear` int(11) DEFAULT NULL,
  `since` date DEFAULT NULL,
  `body` enum('STATIONWAGON','SEDAN','HATCHBACK','MINIVAN','SUV','COUPE','TRUCK','CONVERTIBLE') DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `pricePerHour` double DEFAULT NULL,
  PRIMARY KEY (`licensePlate`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.car: ~3 rows (approximately)
/*!40000 ALTER TABLE `car` DISABLE KEYS */;
REPLACE INTO `car` (`licensePlate`, `ID`, `brand`, `model`, `fuel`, `options`, `engineSize`, `modelYear`, `since`, `body`, `image`, `pricePerHour`) VALUES
	('RH-383-J', 1, 'Audi', 'Q2 1.4 TFSI CoD', 'GASOLINE', NULL, NULL, 2018, '2023-11-23', 'COUPE', '1.jpg', 23.56),
	('V-823-JK', 2, 'Ford', 'TRANSIT CONNECT', 'DIESEL', NULL, NULL, 2017, '2023-11-23', 'MINIVAN', '2.jpg', 12.63),
	('XN-675-S', 3, 'Volvo', 'S90', 'DIESEL', NULL, NULL, 2017, '2023-11-21', 'STATIONWAGON', '3.jpg', 13.56);
/*!40000 ALTER TABLE `car` ENABLE KEYS */;

-- Dumping structure for table automaat.costumer
CREATE TABLE IF NOT EXISTS `costumer` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `lastName` varchar(255) NOT NULL DEFAULT '',
  `firstName` varchar(255) NOT NULL DEFAULT '',
  `birthDate` date NOT NULL,
  `profilePicture` varchar(255) DEFAULT NULL,
  `email` char(50) DEFAULT NULL,
  `password` varchar(350) DEFAULT NULL,
  `reset_token` varchar(250) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  PRIMARY KEY (`nr`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.costumer: ~4 rows (approximately)
/*!40000 ALTER TABLE `costumer` DISABLE KEYS */;
REPLACE INTO `costumer` (`nr`, `lastName`, `firstName`, `birthDate`, `profilePicture`, `email`, `password`, `reset_token`, `token_expiration`, `role`) VALUES
	(1, 'de Boer', 'Klaas', '2000-09-28', NULL, NULL, NULL, NULL, NULL, NULL),
	(6, 'de Vries', 'Colin', '2000-09-28', 'https://automaat.cdevries.dev/profile_pictures/klaasdeboer717_20231208120816.jpg', 'klaasdeboer717@gmail.com', '$2b$12$w0Sjnes7RIEKGRBFrlihEuhk5DTsIq1AsLSJYLHr9ehKA.dGJbIlK', NULL, NULL, NULL),
	(7, 'Karelina', 'Karelton', '1940-05-10', '', 'karelina@karelton.ka', '$2b$12$lcIMUEMjxTDgvtKfCB45.ufktwA89ODJRwvxTwV.IFMWgF0yzB7yO', NULL, NULL, NULL),
	(8, 'Karelina', 'Karelton', '1940-05-10', '', 'karelina@karelton.ka', '$2b$12$/1egJrV6ZSEZY23HU4eDjuM4AsehnbF51MBLXaVBshy91DVI5d3vy', NULL, NULL, NULL);
/*!40000 ALTER TABLE `costumer` ENABLE KEYS */;

-- Dumping structure for table automaat.damage_reports
CREATE TABLE IF NOT EXISTS `damage_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `image_url` varchar(2500) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_damage_reports_costumer` (`user_id`),
  KEY `FK_damage_reports_car` (`car_id`),
  CONSTRAINT `FK_damage_reports_car` FOREIGN KEY (`car_id`) REFERENCES `car` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_damage_reports_costumer` FOREIGN KEY (`user_id`) REFERENCES `costumer` (`nr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.damage_reports: ~4 rows (approximately)
/*!40000 ALTER TABLE `damage_reports` DISABLE KEYS */;
REPLACE INTO `damage_reports` (`id`, `description`, `image_url`, `created_at`, `user_id`, `car_id`) VALUES
	(8, 'flip', '6_2_20231203201506.jpg', '2023-12-03 20:15:06', 6, 2),
	(9, 'oh nee! de auto is stuk', '6_2_20231203202230.jpg', '2023-12-03 20:22:30', 6, 2),
	(10, 'a', '6_2_20231206013430.jpg', '2023-12-06 01:34:30', 6, 2),
	(11, 'oh nee!', '6_1_20231206133819.jpg', '2023-12-06 13:38:19', 6, 1);
/*!40000 ALTER TABLE `damage_reports` ENABLE KEYS */;

-- Dumping structure for table automaat.favorite_cars
CREATE TABLE IF NOT EXISTS `favorite_cars` (
  `customerNr` int(11) NOT NULL,
  `carID` int(11) NOT NULL,
  PRIMARY KEY (`customerNr`,`carID`),
  KEY `carID` (`carID`),
  CONSTRAINT `favorite_cars_ibfk_1` FOREIGN KEY (`customerNr`) REFERENCES `costumer` (`nr`),
  CONSTRAINT `favorite_cars_ibfk_2` FOREIGN KEY (`carID`) REFERENCES `car` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.favorite_cars: ~2 rows (approximately)
/*!40000 ALTER TABLE `favorite_cars` DISABLE KEYS */;
REPLACE INTO `favorite_cars` (`customerNr`, `carID`) VALUES
	(6, 1),
	(6, 3);
/*!40000 ALTER TABLE `favorite_cars` ENABLE KEYS */;

-- Dumping structure for table automaat.inspection
CREATE TABLE IF NOT EXISTS `inspection` (
  `code` varchar(255) NOT NULL,
  `odometer` bigint(20) DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  `photo` blob DEFAULT NULL,
  `completedDate` date DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.inspection: ~0 rows (approximately)
/*!40000 ALTER TABLE `inspection` DISABLE KEYS */;
/*!40000 ALTER TABLE `inspection` ENABLE KEYS */;

-- Dumping structure for table automaat.inspectionphoto
CREATE TABLE IF NOT EXISTS `inspectionphoto` (
  `code` varchar(255) NOT NULL,
  `photo` blob DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.inspectionphoto: ~0 rows (approximately)
/*!40000 ALTER TABLE `inspectionphoto` DISABLE KEYS */;
/*!40000 ALTER TABLE `inspectionphoto` ENABLE KEYS */;

-- Dumping structure for table automaat.location
CREATE TABLE IF NOT EXISTS `location` (
  `streetAddress` varchar(255) DEFAULT NULL,
  `postalCode` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `stateProvince` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.location: ~0 rows (approximately)
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
/*!40000 ALTER TABLE `location` ENABLE KEYS */;

-- Dumping structure for table automaat.rental
CREATE TABLE IF NOT EXISTS `rental` (
  `code` varchar(255) NOT NULL,
  `longitude` float DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `fromDate` date DEFAULT NULL,
  `toDate` date DEFAULT NULL,
  `RentalState` enum('ACTIVE','RESERVED','PICKUP','RETURNED') DEFAULT NULL,
  `customerNr` int(11) DEFAULT NULL,
  `carID` int(11) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `customerNr` (`customerNr`),
  KEY `carID` (`carID`),
  CONSTRAINT `carID` FOREIGN KEY (`carID`) REFERENCES `car` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customerNr` FOREIGN KEY (`customerNr`) REFERENCES `costumer` (`nr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.rental: ~2 rows (approximately)
/*!40000 ALTER TABLE `rental` DISABLE KEYS */;
REPLACE INTO `rental` (`code`, `longitude`, `latitude`, `fromDate`, `toDate`, `RentalState`, `customerNr`, `carID`) VALUES
	('1', 53.2409, 6.54567, '2023-11-23', '2024-11-23', 'ACTIVE', 6, 1),
	('2', 53.2209, 6.55417, '2023-11-23', '2025-11-23', 'ACTIVE', 6, 2);
/*!40000 ALTER TABLE `rental` ENABLE KEYS */;

-- Dumping structure for table automaat.repair
CREATE TABLE IF NOT EXISTS `repair` (
  `description` varchar(255) DEFAULT NULL,
  `repairStatus` enum('PLANNED','DOING','DONE','CANCELLED') DEFAULT NULL,
  `dateCompleted` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.repair: ~0 rows (approximately)
/*!40000 ALTER TABLE `repair` DISABLE KEYS */;
/*!40000 ALTER TABLE `repair` ENABLE KEYS */;

-- Dumping structure for table automaat.route
CREATE TABLE IF NOT EXISTS `route` (
  `code` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `LocalDate` date DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.route: ~0 rows (approximately)
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
/*!40000 ALTER TABLE `route` ENABLE KEYS */;

-- Dumping structure for table automaat.tickets
CREATE TABLE IF NOT EXISTS `tickets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `description` varchar(5000) DEFAULT NULL,
  `status` enum('open','busy','closed') DEFAULT 'open',
  PRIMARY KEY (`ID`),
  KEY `FK__costumer` (`user_id`),
  CONSTRAINT `FK__costumer` FOREIGN KEY (`user_id`) REFERENCES `costumer` (`nr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.tickets: ~2 rows (approximately)
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
REPLACE INTO `tickets` (`ID`, `user_id`, `description`, `status`) VALUES
	(1, 6, 'help', 'open'),
	(3, 6, 'blablba', 'open');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
