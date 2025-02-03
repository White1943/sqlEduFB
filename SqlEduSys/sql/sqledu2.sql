/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 80022
Source Host           : localhost:3306
Source Database       : sqledu

Target Server Type    : MYSQL
Target Server Version : 80022
File Encoding         : 65001

Date: 2025-01-20 10:39:22
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'w', 'w@qq.com', '1', '2025-01-18 22:10:58', '2025-01-19 22:11:03', '1', '1');
INSERT INTO `users` VALUES ('2', 'test', '33@qq.com', 'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac', '2025-01-19 23:58:25', null, '1', '0');
INSERT INTO `users` VALUES ('4', 'test2', '22', 'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d', '2025-01-20 00:02:05', null, '1', '0');
INSERT INTO `users` VALUES ('5', 't', 't', 'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d', '2025-01-20 00:09:55', null, '1', '0');
INSERT INTO `users` VALUES ('6', 'tt', 'tt', 'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70', '2025-01-20 00:26:57', null, '1', '0');
