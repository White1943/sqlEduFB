/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 80022
Source Host           : localhost:3306
Source Database       : tpcd

Target Server Type    : MYSQL
Target Server Version : 80022
File Encoding         : 65001

Date: 2025-03-03 14:13:32
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `C_CUSTKEY` int NOT NULL,
  `C_NAME` varchar(25) NOT NULL,
  `C_ADDRESS` varchar(40) NOT NULL,
  `C_NATIONKEY` int NOT NULL,
  `C_PHONE` char(15) NOT NULL,
  `C_ACCTBAL` decimal(15,2) NOT NULL,
  `C_MKTSEGMENT` char(10) NOT NULL,
  `C_COMMENT` varchar(117) NOT NULL,
  PRIMARY KEY (`C_CUSTKEY`),
  KEY `CUSTOMER_FK1` (`C_NATIONKEY`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`C_NATIONKEY`) REFERENCES `nation` (`N_NATIONKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lineitem
-- ----------------------------
DROP TABLE IF EXISTS `lineitem`;
CREATE TABLE `lineitem` (
  `L_ORDERKEY` int NOT NULL,
  `L_PARTKEY` int NOT NULL,
  `L_SUPPKEY` int NOT NULL,
  `L_LINENUMBER` int NOT NULL,
  `L_QUANTITY` decimal(15,2) NOT NULL,
  `L_EXTENDEDPRICE` decimal(15,2) NOT NULL,
  `L_DISCOUNT` decimal(15,2) NOT NULL,
  `L_TAX` decimal(15,2) NOT NULL,
  `L_RETURNFLAG` char(1) NOT NULL,
  `L_LINESTATUS` char(1) NOT NULL,
  `L_SHIPDATE` date NOT NULL,
  `L_COMMITDATE` date NOT NULL,
  `L_RECEIPTDATE` date NOT NULL,
  `L_SHIPINSTRUCT` char(25) NOT NULL,
  `L_SHIPMODE` char(10) NOT NULL,
  `L_COMMENT` varchar(44) NOT NULL,
  PRIMARY KEY (`L_ORDERKEY`,`L_LINENUMBER`),
  KEY `LINEITEM_FK2` (`L_PARTKEY`,`L_SUPPKEY`),
  CONSTRAINT `lineitem_ibfk_1` FOREIGN KEY (`L_ORDERKEY`) REFERENCES `orders` (`O_ORDERKEY`),
  CONSTRAINT `lineitem_ibfk_2` FOREIGN KEY (`L_PARTKEY`, `L_SUPPKEY`) REFERENCES `partsupp` (`PS_PARTKEY`, `PS_SUPPKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for nation
-- ----------------------------
DROP TABLE IF EXISTS `nation`;
CREATE TABLE `nation` (
  `N_NATIONKEY` int NOT NULL,
  `N_NAME` char(25) NOT NULL,
  `N_REGIONKEY` int NOT NULL,
  `N_COMMENT` varchar(152) DEFAULT NULL,
  PRIMARY KEY (`N_NATIONKEY`),
  KEY `NATION_FK1` (`N_REGIONKEY`),
  CONSTRAINT `nation_ibfk_1` FOREIGN KEY (`N_REGIONKEY`) REFERENCES `region` (`R_REGIONKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `O_ORDERKEY` int NOT NULL,
  `O_CUSTKEY` int NOT NULL,
  `O_ORDERSTATUS` char(1) NOT NULL,
  `O_TOTALPRICE` decimal(15,2) NOT NULL,
  `O_ORDERDATE` date NOT NULL,
  `O_ORDERPRIORITY` char(15) NOT NULL,
  `O_CLERK` char(15) NOT NULL,
  `O_SHIPPRIORITY` int NOT NULL,
  `O_COMMENT` varchar(79) NOT NULL,
  PRIMARY KEY (`O_ORDERKEY`),
  KEY `ORDERS_FK1` (`O_CUSTKEY`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`O_CUSTKEY`) REFERENCES `customer` (`C_CUSTKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for part
-- ----------------------------
DROP TABLE IF EXISTS `part`;
CREATE TABLE `part` (
  `P_PARTKEY` int NOT NULL,
  `P_NAME` varchar(55) NOT NULL,
  `P_MFGR` char(25) NOT NULL,
  `P_BRAND` char(10) NOT NULL,
  `P_TYPE` varchar(25) NOT NULL,
  `P_SIZE` int NOT NULL,
  `P_CONTAINER` char(10) NOT NULL,
  `P_RETAILPRICE` decimal(15,2) NOT NULL,
  `P_COMMENT` varchar(23) NOT NULL,
  PRIMARY KEY (`P_PARTKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for partsupp
-- ----------------------------
DROP TABLE IF EXISTS `partsupp`;
CREATE TABLE `partsupp` (
  `PS_PARTKEY` int NOT NULL,
  `PS_SUPPKEY` int NOT NULL,
  `PS_AVAILQTY` int NOT NULL,
  `PS_SUPPLYCOST` decimal(15,2) NOT NULL,
  `PS_COMMENT` varchar(199) NOT NULL,
  PRIMARY KEY (`PS_PARTKEY`,`PS_SUPPKEY`),
  KEY `PARTSUPP_FK1` (`PS_SUPPKEY`),
  CONSTRAINT `partsupp_ibfk_1` FOREIGN KEY (`PS_SUPPKEY`) REFERENCES `supplier` (`S_SUPPKEY`),
  CONSTRAINT `partsupp_ibfk_2` FOREIGN KEY (`PS_PARTKEY`) REFERENCES `part` (`P_PARTKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for region
-- ----------------------------
DROP TABLE IF EXISTS `region`;
CREATE TABLE `region` (
  `R_REGIONKEY` int NOT NULL,
  `R_NAME` char(25) NOT NULL,
  `R_COMMENT` varchar(152) DEFAULT NULL,
  PRIMARY KEY (`R_REGIONKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `S_SUPPKEY` int NOT NULL,
  `S_NAME` char(25) NOT NULL,
  `S_ADDRESS` varchar(40) NOT NULL,
  `S_NATIONKEY` int NOT NULL,
  `S_PHONE` char(15) NOT NULL,
  `S_ACCTBAL` decimal(15,2) NOT NULL,
  `S_COMMENT` varchar(101) NOT NULL,
  PRIMARY KEY (`S_SUPPKEY`),
  KEY `SUPPLIER_FK1` (`S_NATIONKEY`),
  CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`S_NATIONKEY`) REFERENCES `nation` (`N_NATIONKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
