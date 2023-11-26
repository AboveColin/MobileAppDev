-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.11.1-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
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
  PRIMARY KEY (`licensePlate`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.car: ~3 rows (approximately)
/*!40000 ALTER TABLE `car` DISABLE KEYS */;
INSERT INTO `car` (`licensePlate`, `ID`, `brand`, `model`, `fuel`, `options`, `engineSize`, `modelYear`, `since`, `body`, `image`) VALUES
	('RH-383-J', 1, 'Audi', 'Q2 1.4 TFSI CoD', 'GASOLINE', NULL, NULL, 2018, '2023-11-23', 'COUPE', 'https://cdn.autofinancier.nl/192234949/1.jpg'),
	('V-823-JK', 2, 'Ford', 'TRANSIT CONNECT', 'DIESEL', NULL, NULL, 2017, '2023-11-23', 'MINIVAN', 'https://cdn.autofinancier.nl/344213506/1.jpg'),
	('XN-675-S', 3, 'Volvo', 'S90', 'DIESEL', NULL, NULL, 2017, '2023-11-21', 'STATIONWAGON', 'https://cdn.autofinancier.nl/875870110/1.jpg');
/*!40000 ALTER TABLE `car` ENABLE KEYS */;

-- Dumping structure for table automaat.costumer
CREATE TABLE IF NOT EXISTS `costumer` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `lastName` varchar(255) NOT NULL DEFAULT '',
  `firstName` varchar(255) NOT NULL DEFAULT '',
  `birthDate` date NOT NULL,
  `profilePicture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`nr`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table automaat.costumer: ~0 rows (approximately)
/*!40000 ALTER TABLE `costumer` DISABLE KEYS */;
INSERT INTO `costumer` (`nr`, `lastName`, `firstName`, `birthDate`, `profilePicture`) VALUES
	(1, 'Colin', 'de Vries', '2000-09-28', NULL);
/*!40000 ALTER TABLE `costumer` ENABLE KEYS */;

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
INSERT INTO `rental` (`code`, `longitude`, `latitude`, `fromDate`, `toDate`, `RentalState`, `customerNr`, `carID`) VALUES
	('2', 53.2409, 6.54567, '2023-11-23', '2024-11-23', 'ACTIVE', 1, 1),
	('aaaa', 53.2209, 6.55417, '2023-11-23', '2025-11-23', 'ACTIVE', 1, 2);
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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
