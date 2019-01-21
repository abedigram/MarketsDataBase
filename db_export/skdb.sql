-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 21, 2019 at 05:18 AM
-- Server version: 10.1.26-MariaDB
-- PHP Version: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skdb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `editCustomer` (IN `editorID` INT, IN `toEditID` INT, IN `customerID1` INT, IN `pass1` VARCHAR(256), IN `email1` VARCHAR(20), IN `fname1` VARCHAR(20), IN `lname1` VARCHAR(20), IN `postcode1` INT, IN `gender1` INT, IN `credit1` INT)  BEGIN
	IF editorID = toEditID THEN
    UPDATE customer
    SET customerID = customerID1,
    	pass = pass1,
        email = email1,
        fname = fname1,
        lname = lname1,
        postcode = postcode1,
        gender = gender1,
        credit = credit1
	WHERE customerID = toEditID;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `customerID` int(11) DEFAULT NULL,
  `address` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`customerID`, `address`) VALUES
(1, 'cus1address1');

-- --------------------------------------------------------

--
-- Table structure for table `banklog`
--

CREATE TABLE `banklog` (
  `logID` int(11) NOT NULL,
  `customerID` int(11) DEFAULT NULL,
  `bankName` varchar(20) DEFAULT NULL,
  `creditAmount` int(11) DEFAULT NULL,
  `transactionDate` datetime DEFAULT NULL,
  `transactionType` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `banklog`
--

INSERT INTO `banklog` (`logID`, `customerID`, `bankName`, `creditAmount`, `transactionDate`, `transactionType`) VALUES
(1, 3, 'Tejarat', 399, '2019-01-20 23:12:02', 'addCredit'),
(3, 2, 'Saderat', 557, '2019-01-20 23:38:38', 'addCredit');

--
-- Triggers `banklog`
--
DELIMITER $$
CREATE TRIGGER `bankAddCredit` AFTER INSERT ON `banklog` FOR EACH ROW BEGIN
	DECLARE a int;
    DECLARE d int;
IF NEW.transactionType = "addCredit" THEN
    SET d = new.customerID;
    SET a = new.creditAmount;
    UPDATE customer
    SET credit = credit + a
    where customerID = d;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` int(11) NOT NULL,
  `pass` varchar(256) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `postcode` int(11) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `pass`, `email`, `fname`, `lname`, `postcode`, `gender`, `credit`) VALUES
(1, '£ãLúMS2ù3~é,ºSè', '1@1.1', '1name', '1family', 1111111111, 0, 940),
(2, 'pbÅ‡¡óB=ibÉÚ!ID[ÉÆœ~0/)ªÇðæü', '2@22.2', '2name', '2famil2y', 222222, 1, 2057),
(3, '™Ãµ«Fåô$:Ã\ròzGTD[ÉÆœ~0/)ªÇðæü', '3@3.3', '3name', '3family', 333333333, 1, 899),
(5, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `passHash` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
	DECLARE p varchar(256);
    set p = new.pass;
    set new.pass = aes_encrypt(p,"1234");
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `passHashUpdate` BEFORE UPDATE ON `customer` FOR EACH ROW BEGIN
DECLARE p varchar(256);
set p = new.pass;
set new.pass = aes_encrypt(p,"1234");

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `market`
--

CREATE TABLE `market` (
  `marketID` int(11) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `address` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `manager` varchar(20) DEFAULT NULL,
  `openTime` time DEFAULT NULL,
  `closeTime` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `market`
--

INSERT INTO `market` (`marketID`, `title`, `city`, `address`, `phone`, `manager`, `openTime`, `closeTime`) VALUES
(1, 'm1', 'Tehran', 'm1address', 'm1phone', 'm1manager', '06:00:00', '12:00:00'),
(2, 'm2', 'Tehran', 'm2address', 'm2phone', 'm2manager', '00:00:00', '23:00:00'),
(3, 'm3', 'Tehran', 'm3address', 'm3phone', 'm3manager', '00:00:00', '23:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `operator`
--

CREATE TABLE `operator` (
  `operatorID` int(11) NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `marketID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `operator`
--

INSERT INTO `operator` (`operatorID`, `fname`, `lname`, `marketID`) VALUES
(1, 'op1name', 'op1family', 1),
(2, 'op2name', 'op2family', 2),
(3, 'op3name', 'op3family', 3);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `ordersID` int(11) NOT NULL,
  `marketID` int(11) DEFAULT NULL,
  `customerID` int(11) DEFAULT NULL,
  `orderStatus` varchar(20) DEFAULT NULL,
  `payment` varchar(20) DEFAULT NULL,
  `orderDate` datetime DEFAULT NULL,
  `address` varchar(20) DEFAULT NULL,
  `shipperID` int(11) DEFAULT NULL,
  `productID` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`ordersID`, `marketID`, `customerID`, `orderStatus`, `payment`, `orderDate`, `address`, `shipperID`, `productID`, `amount`) VALUES
(1, 1, 1, 'registered', 'credit', '2019-01-21 07:00:00', 'cus1address1', 1, NULL, NULL),
(2, 2, 1, 'registered', 'credit', '2019-01-21 00:34:57', 'cus1address1', 1, NULL, NULL),
(4, 1, 1, 'registered', 'credit', '2019-01-21 01:18:13', 'cus1address1', NULL, 1, 3),
(5, 1, 1, 'registered', 'credit', '2019-01-21 01:21:45', 'cus1address1', NULL, 1, 3),
(6, 2, 1, 'registered', 'credit', '2019-01-21 01:23:43', 'cus1address1', NULL, 1, 3),
(7, 2, 1, 'registered', 'credit', '2019-01-21 01:29:41', 'cus1address1', NULL, 1, 3),
(8, 2, 1, 'registered', 'credit', '2019-01-21 01:31:19', 'cus1address1', NULL, 1, 3),
(9, 2, 1, 'registered', 'credit', '2019-01-21 01:35:12', 'cus1address1', NULL, 1, 3),
(10, 2, 1, 'registered', 'credit', '2019-01-21 01:37:09', 'cus1address1', NULL, 1, 3),
(11, 2, 1, 'registered', 'credit', '2019-01-21 01:38:28', 'cus1address1', NULL, 1, 3),
(12, 2, 1, 'registered', 'credit', '2019-01-21 01:41:04', 'cus1address1', NULL, 1, 3),
(13, 2, 1, 'registered', 'credit', '2019-01-21 01:44:15', 'cus1address1', NULL, 1, 3),
(14, 2, 1, 'registered', 'credit', '2019-01-21 01:47:36', 'cus1address1', NULL, 1, 3),
(15, 2, 1, 'registered', 'credit', '2019-01-21 01:49:02', 'cus1address1', NULL, 2, 3),
(16, 2, 1, 'registered', 'credit', '2019-01-21 02:05:40', 'cus1address1', NULL, 2, 3),
(18, 2, 1, 'registered', 'credit', '2019-01-21 02:08:25', 'cus1address1', NULL, 2, 3),
(19, 2, 1, 'sending', 'credit', '2019-01-21 02:27:14', 'cus1address1', NULL, 2, 3),
(20, 2, 1, 'registered', 'credit', '2019-01-21 02:54:36', 'cus1address1', 2, 2, 3),
(22, 2, 1, 'ignored', 'credit', '2019-01-21 03:36:04', 'cus1address1', 2, 2, 3);

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `op1` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
  DECLARE opens time;
  DECLARE closes time;
  DECLARE mAmount int;
  DECLARE oAmount int;
  DECLARE shippers varchar(20);
  DECLARE price int;
  DECLARE message varchar(20);
  DECLARE oldstatus varchar(20);
  DECLARE newstatus varchar(20);
  SET oldstatus = new.orderstatus;
    SET opens = (SELECT m.openTime
    FROM market as m
    WHERE marketID = new.marketID);
    
    SET closes = (SELECT m.closeTime
    FROM market as m
    WHERE marketID = new.marketID);
   
     SET mAmount = (SELECT p.amount
                   FROM product as p
                   WHERE p.marketID = new.marketID
                   and p.productID = new.productID);
     SET oAmount = new.amount;
     
     SET shippers = (SELECT s.shipperStatus
                    from shipper as s
                    where new.marketID = s.marketID);
  SET price = (SELECT p.price * new.amount
                   FROM product as p
                   WHERE p.marketID = new.marketID
                   and p.productID = new.productID); 

                   
IF date_format(NOW(),'%H:%i:%s') BETWEEN date_format(opens,'%H:%i:%s') and date_format(closes,'%H:%i:%s') THEN
IF mAmount >= oAmount THEN
IF shippers = "free" THEN
			  SET message = "no problem";
              SET newstatus = "sending";
              UPDATE shipper SET shipperstatus = "busy" WHERE new.marketID = shipper.marketID;
              if new.payment = "bank" THEN
              INSERT INTO banklog (customerID,bankName,creditAmount,transactionDate,transactionType) values (new.customerID,"Shaparak",price,now(),"internetShop");
              ELSEIF new.payment = "credit" THEN
              UPDATE customer SET credit = credit - price WHERE new.customerID = customerID;   
        END IF; 
ELSE SET newstatus = "ignored"; SET message = "no free shipper";
END IF;
ELSE SET newstatus = "ignored"; SET message = "not much amount";
END IF;
ELSE SET newstatus = "ignored"; SET message = "market is closed";
END IF;
INSERT INTO orderslog(supporterID, operatorID, ordersID, statusOld, statusNew, why, logDate) VALUES (new.marketID,new.marketID,new.OrdersID,oldStatus,newstatus,message,NOW());
SET new.orderstatus = newstatus;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orderslog`
--

CREATE TABLE `orderslog` (
  `logID` int(11) NOT NULL,
  `supporterID` int(11) DEFAULT NULL,
  `operatorID` int(11) DEFAULT NULL,
  `ordersID` int(11) DEFAULT NULL,
  `statusOld` varchar(20) DEFAULT NULL,
  `statusNew` varchar(20) DEFAULT NULL,
  `why` varchar(20) DEFAULT NULL,
  `logDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orderslog`
--

INSERT INTO `orderslog` (`logID`, `supporterID`, `operatorID`, `ordersID`, `statusOld`, `statusNew`, `why`, `logDate`) VALUES
(1, 2, 2, 0, 'registered', 'ignored', 'no free shipper', '2019-01-21 03:36:04');

-- --------------------------------------------------------

--
-- Table structure for table `phones`
--

CREATE TABLE `phones` (
  `customerID` int(11) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productID` int(11) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `marketID` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productID`, `title`, `price`, `discount`, `marketID`, `amount`) VALUES
(1, 'p1', 30, 0, 1, 10),
(2, 'p2', 20, 0, 2, 10);

-- --------------------------------------------------------

--
-- Table structure for table `shipper`
--

CREATE TABLE `shipper` (
  `shipperID` int(11) NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `shipperStatus` varchar(20) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `marketID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shipper`
--

INSERT INTO `shipper` (`shipperID`, `fname`, `lname`, `phone`, `shipperStatus`, `credit`, `marketID`) VALUES
(1, 'ship1name', 'ship2family', 'ship1phone', 'free', 0, 1),
(2, 'ship2name', 'ship2family', 'ship2phone', 'free', NULL, 2),
(3, 'ship3name', 'ship3family', 'ship3phone', 'free', 0, NULL);

--
-- Triggers `shipper`
--
DELIMITER $$
CREATE TRIGGER `op2` BEFORE UPDATE ON `shipper` FOR EACH ROW BEGIN
  DECLARE s varchar(20);
    DECLARE price int;
    DECLARE c int;
    SET c = new.credit;
    SET price = (SELECT p.price * o.amount * 0.05
                   from orders as o, orderslog as ol, product as p
                   where new.shipperID = ol.supporterID
                   and o.ordersID=  ol.ordersID
                   and o.productID = p.productID);
    
    IF new.shipperstatus = "busy" THEN
    SET s = "free";
    ELSE
    SET s = "busy";
    END IF;
  

    IF new.shipperstatus = "free" THEN               
    SET new.credit = c + price ;
    END IF;
    
    INSERT INTO shipperslog (shipperID,statusOld,statusNew,logDate) VALUES
    (new.shipperID,s,new.shipperstatus,now());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shipperslog`
--

CREATE TABLE `shipperslog` (
  `shipperID` int(11) DEFAULT NULL,
  `statusOld` varchar(20) DEFAULT NULL,
  `statusNew` varchar(20) DEFAULT NULL,
  `logDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shipperslog`
--

INSERT INTO `shipperslog` (`shipperID`, `statusOld`, `statusNew`, `logDate`) VALUES
(2, 'free', 'busy', '2019-01-21 04:45:15'),
(2, 'busy', 'free', '2019-01-21 04:47:20');

-- --------------------------------------------------------

--
-- Table structure for table `supporter`
--

CREATE TABLE `supporter` (
  `supporterID` int(11) NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `address` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `marketID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `supporter`
--

INSERT INTO `supporter` (`supporterID`, `fname`, `lname`, `address`, `phone`, `marketID`) VALUES
(1, 'sup1name', 'sup1family', 'sup1address', 'sup1phone', 1),
(2, 'sup2name', 'sup2family', 'sup2address', 'sup2phone', 2),
(3, 'sup3name', 'sup3family', 'sup3address', 'sup3phone', 3);

-- --------------------------------------------------------

--
-- Table structure for table `tempdate`
--

CREATE TABLE `tempdate` (
  `date1` date DEFAULT NULL,
  `time1` time DEFAULT NULL,
  `datetime1` datetime DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `iff` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tempdate`
--

INSERT INTO `tempdate` (`date1`, `time1`, `datetime1`, `amount`, `iff`) VALUES
(NULL, '06:00:00', NULL, NULL, NULL),
(NULL, '00:00:00', NULL, NULL, NULL),
(NULL, NULL, NULL, 10, NULL),
(NULL, NULL, NULL, 3, NULL),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'amount is not ok'),
(NULL, NULL, NULL, NULL, NULL),
(NULL, NULL, NULL, 3, NULL),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, NULL),
(NULL, NULL, NULL, 3, NULL),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, 10, NULL),
(NULL, NULL, NULL, 3, NULL),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'amount is ok'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'amount is ok'),
(NULL, NULL, NULL, NULL, 'shipper is free'),
(NULL, NULL, NULL, NULL, 'date is ok'),
(NULL, NULL, NULL, NULL, 'amount is ok'),
(NULL, NULL, NULL, NULL, 'shipper is free');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `banklog`
--
ALTER TABLE `banklog`
  ADD PRIMARY KEY (`logID`),
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`);

--
-- Indexes for table `market`
--
ALTER TABLE `market`
  ADD PRIMARY KEY (`marketID`);

--
-- Indexes for table `operator`
--
ALTER TABLE `operator`
  ADD PRIMARY KEY (`operatorID`),
  ADD KEY `marketID` (`marketID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`ordersID`),
  ADD KEY `marketID` (`marketID`),
  ADD KEY `customerID` (`customerID`),
  ADD KEY `shipperID` (`shipperID`),
  ADD KEY `productID` (`productID`);

--
-- Indexes for table `orderslog`
--
ALTER TABLE `orderslog`
  ADD PRIMARY KEY (`logID`);

--
-- Indexes for table `phones`
--
ALTER TABLE `phones`
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productID`),
  ADD KEY `marketID` (`marketID`);

--
-- Indexes for table `shipper`
--
ALTER TABLE `shipper`
  ADD PRIMARY KEY (`shipperID`),
  ADD KEY `marketID` (`marketID`);

--
-- Indexes for table `shipperslog`
--
ALTER TABLE `shipperslog`
  ADD KEY `shipperID` (`shipperID`);

--
-- Indexes for table `supporter`
--
ALTER TABLE `supporter`
  ADD PRIMARY KEY (`supporterID`),
  ADD KEY `marketID` (`marketID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banklog`
--
ALTER TABLE `banklog`
  MODIFY `logID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `market`
--
ALTER TABLE `market`
  MODIFY `marketID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `operator`
--
ALTER TABLE `operator`
  MODIFY `operatorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `ordersID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `orderslog`
--
ALTER TABLE `orderslog`
  MODIFY `logID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shipper`
--
ALTER TABLE `shipper`
  MODIFY `shipperID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `supporter`
--
ALTER TABLE `supporter`
  MODIFY `supporterID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `banklog`
--
ALTER TABLE `banklog`
  ADD CONSTRAINT `banklog_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `operator`
--
ALTER TABLE `operator`
  ADD CONSTRAINT `operator_ibfk_1` FOREIGN KEY (`marketID`) REFERENCES `market` (`marketID`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`marketID`) REFERENCES `market` (`marketID`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`shipperID`) REFERENCES `shipper` (`shipperID`),
  ADD CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`);

--
-- Constraints for table `phones`
--
ALTER TABLE `phones`
  ADD CONSTRAINT `phones_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`marketID`) REFERENCES `market` (`marketID`);

--
-- Constraints for table `shipper`
--
ALTER TABLE `shipper`
  ADD CONSTRAINT `shipper_ibfk_1` FOREIGN KEY (`marketID`) REFERENCES `market` (`marketID`);

--
-- Constraints for table `shipperslog`
--
ALTER TABLE `shipperslog`
  ADD CONSTRAINT `shipperslog_ibfk_1` FOREIGN KEY (`shipperID`) REFERENCES `shipper` (`shipperID`);

--
-- Constraints for table `supporter`
--
ALTER TABLE `supporter`
  ADD CONSTRAINT `supporter_ibfk_1` FOREIGN KEY (`marketID`) REFERENCES `market` (`marketID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
