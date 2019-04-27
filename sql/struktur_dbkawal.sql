/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80014
 Source Host           : localhost:3306
 Source Schema         : dbkawal

 Target Server Type    : MySQL
 Target Server Version : 80014
 File Encoding         : 65001

 Date: 27/04/2019 13:35:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_kec
-- ----------------------------
DROP TABLE IF EXISTS `t_kec`;
CREATE TABLE `t_kec`  (
  `kdkec` int(255) NOT NULL,
  `kdkota` int(255) NOT NULL,
  `kec` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`kdkec`) USING BTREE,
  INDEX `kdkota`(`kdkota`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_kel
-- ----------------------------
DROP TABLE IF EXISTS `t_kel`;
CREATE TABLE `t_kel`  (
  `kdkel` int(255) NOT NULL,
  `kdkec` int(255) NOT NULL,
  `kel` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `last` datetime(0) NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`kdkel`) USING BTREE,
  INDEX `kdkec`(`kdkec`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_kota
-- ----------------------------
DROP TABLE IF EXISTS `t_kota`;
CREATE TABLE `t_kota`  (
  `kdkota` int(255) NOT NULL,
  `kdprov` int(255) NOT NULL,
  `kota` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`kdkota`) USING BTREE,
  INDEX `kdprov`(`kdprov`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_prov
-- ----------------------------
DROP TABLE IF EXISTS `t_prov`;
CREATE TABLE `t_prov`  (
  `kdprov` int(255) NOT NULL,
  `prov` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`kdprov`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_tps
-- ----------------------------
DROP TABLE IF EXISTS `t_tps`;
CREATE TABLE `t_tps`  (
  `kdtps` int(255) NOT NULL,
  `kdkel` int(255) NOT NULL,
  `nama` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `no` int(11) NULL DEFAULT NULL,
  `kpu1` int(255) NULL DEFAULT NULL,
  `kpu2` int(255) NULL DEFAULT NULL,
  `kwl1` int(255) NULL DEFAULT NULL,
  `kwl2` int(255) NULL DEFAULT NULL,
  `pnt1` int(255) NULL DEFAULT NULL,
  `pnt2` int(255) NULL DEFAULT NULL,
  PRIMARY KEY (`kdtps`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for v01_kota
-- ----------------------------
DROP VIEW IF EXISTS `v01_kota`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v01_kota` AS select `t_kota`.`kdkota` AS `kdkota`,`t_kota`.`kota` AS `kota`,`t_kota`.`kdprov` AS `kdprov`,`t_prov`.`prov` AS `prov` from (`t_kota` join `t_prov` on((`t_kota`.`kdprov` = `t_prov`.`kdprov`)));

-- ----------------------------
-- View structure for v02_kec
-- ----------------------------
DROP VIEW IF EXISTS `v02_kec`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v02_kec` AS select `t_kec`.`kdkec` AS `kdkec`,`t_kec`.`kec` AS `kec`,`t_kec`.`kdkota` AS `kdkota`,`v01_kota`.`kota` AS `kota`,`v01_kota`.`kdprov` AS `kdprov`,`v01_kota`.`prov` AS `prov` from (`t_kec` join `v01_kota` on((`t_kec`.`kdkota` = `v01_kota`.`kdkota`)));

-- ----------------------------
-- View structure for v03_kel
-- ----------------------------
DROP VIEW IF EXISTS `v03_kel`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v03_kel` AS select `t_kel`.`kdkel` AS `kdkel`,`t_kel`.`kel` AS `kel`,`t_kel`.`last` AS `last`,`t_kel`.`kdkec` AS `kdkec`,`v02_kec`.`kec` AS `kec`,`v02_kec`.`kdkota` AS `kdkota`,`v02_kec`.`kota` AS `kota`,`v02_kec`.`kdprov` AS `kdprov`,`v02_kec`.`prov` AS `prov` from (`t_kel` join `v02_kec` on((`t_kel`.`kdkec` = `v02_kec`.`kdkec`)));

-- ----------------------------
-- View structure for v04_kel_uri
-- ----------------------------
DROP VIEW IF EXISTS `v04_kel_uri`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v04_kel_uri` AS select `v03_kel`.`kdkel` AS `kdkel`,`v03_kel`.`kel` AS `kel`,`v03_kel`.`last` AS `last`,`v03_kel`.`kdkec` AS `kdkec`,`v03_kel`.`kec` AS `kec`,`v03_kel`.`kdkota` AS `kdkota`,`v03_kel`.`kota` AS `kota`,`v03_kel`.`kdprov` AS `kdprov`,`v03_kel`.`prov` AS `prov`,concat(`v03_kel`.`kdprov`,'/',`v03_kel`.`kdkota`,'/',`v03_kel`.`kdkec`,'/',`v03_kel`.`kdkel`) AS `kpu_uri` from `v03_kel`;

SET FOREIGN_KEY_CHECKS = 1;
