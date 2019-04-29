/*
 Navicat Premium Data Transfer

 Source Server         : KawalMySQL
 Source Server Type    : MySQL
 Source Server Version : 50562
 Source Host           : localhost:3306
 Source Schema         : dbkawal

 Target Server Type    : MySQL
 Target Server Version : 50562
 File Encoding         : 65001

 Date: 29/04/2019 12:13:03
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
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for t_kel
-- ----------------------------
DROP TABLE IF EXISTS `t_kel`;
CREATE TABLE `t_kel`  (
  `kdkel` int(255) NOT NULL,
  `kdkec` int(255) NOT NULL,
  `kel` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `last` datetime NULL DEFAULT '2000-01-01 00:00:00',
  `lastpnt` datetime NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`kdkel`) USING BTREE,
  INDEX `kdkec`(`kdkec`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

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
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for t_prov
-- ----------------------------
DROP TABLE IF EXISTS `t_prov`;
CREATE TABLE `t_prov`  (
  `kdprov` int(255) NOT NULL,
  `prov` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`kdprov`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

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
  `kput` int(255) NULL DEFAULT NULL,
  `kpus` int(255) NULL DEFAULT NULL,
  `kpuj` int(255) NULL DEFAULT NULL,
  `kpuimg` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `kwl1` int(255) NULL DEFAULT NULL,
  `kwl2` int(255) NULL DEFAULT NULL,
  `pnt1` int(255) NULL DEFAULT NULL,
  `pnt2` int(255) NULL DEFAULT NULL,
  PRIMARY KEY (`kdtps`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

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
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v03_kel` AS select `t_kel`.`kdkel` AS `kdkel`,`t_kel`.`kel` AS `kel`,`t_kel`.`last` AS `last`,`t_kel`.`lastpnt` AS `lastpnt`,`t_kel`.`kdkec` AS `kdkec`,`v02_kec`.`kec` AS `kec`,`v02_kec`.`kdkota` AS `kdkota`,`v02_kec`.`kota` AS `kota`,`v02_kec`.`kdprov` AS `kdprov`,`v02_kec`.`prov` AS `prov` from (`t_kel` join `v02_kec` on((`t_kel`.`kdkec` = `v02_kec`.`kdkec`)));

-- ----------------------------
-- View structure for v04_kel_uri
-- ----------------------------
DROP VIEW IF EXISTS `v04_kel_uri`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v04_kel_uri` AS select `v03_kel`.`kdkel` AS `kdkel`,`v03_kel`.`kel` AS `kel`,`v03_kel`.`last` AS `last`,`v03_kel`.`lastpnt` AS `lastpnt`,`v03_kel`.`kdkec` AS `kdkec`,`v03_kel`.`kec` AS `kec`,`v03_kel`.`kdkota` AS `kdkota`,`v03_kel`.`kota` AS `kota`,`v03_kel`.`kdprov` AS `kdprov`,`v03_kel`.`prov` AS `prov`,concat(`v03_kel`.`kdprov`,'/',`v03_kel`.`kdkota`,'/',`v03_kel`.`kdkec`,'/',`v03_kel`.`kdkel`) AS `kpu_uri` from `v03_kel`;

-- ----------------------------
-- View structure for v10_tps_cmp
-- ----------------------------
DROP VIEW IF EXISTS `v10_tps_cmp`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v10_tps_cmp` AS select `t_tps`.`kdtps` AS `kdtps`,`t_tps`.`kdkel` AS `kdkel`,`t_tps`.`nama` AS `nama`,`t_tps`.`no` AS `no`,`t_tps`.`kpu1` AS `kpu1`,`t_tps`.`kpu2` AS `kpu2`,`t_tps`.`kwl1` AS `kwl1`,`t_tps`.`kwl2` AS `kwl2`,ifnull((`t_tps`.`kpu1` - `t_tps`.`kwl1`),0) AS `cmp1`,ifnull((`t_tps`.`kpu2` - `t_tps`.`kwl2`),0) AS `cmp2` from `t_tps`;

-- ----------------------------
-- View structure for v11_tps_cmponly
-- ----------------------------
DROP VIEW IF EXISTS `v11_tps_cmponly`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v11_tps_cmponly` AS select `v10_tps_cmp`.`kdtps` AS `kdtps`,`v10_tps_cmp`.`kdkel` AS `kdkel`,`v10_tps_cmp`.`nama` AS `nama`,`v10_tps_cmp`.`no` AS `no`,`v10_tps_cmp`.`kpu1` AS `kpu1`,`v10_tps_cmp`.`kpu2` AS `kpu2`,`v10_tps_cmp`.`kwl1` AS `kwl1`,`v10_tps_cmp`.`kwl2` AS `kwl2`,`v10_tps_cmp`.`cmp1` AS `cmp1`,`v10_tps_cmp`.`cmp2` AS `cmp2` from `v10_tps_cmp` where ((`v10_tps_cmp`.`cmp1` <> 0) or (`v10_tps_cmp`.`cmp2` <> 0));

-- ----------------------------
-- View structure for v12_tps_cmpdetails
-- ----------------------------
DROP VIEW IF EXISTS `v12_tps_cmpdetails`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v12_tps_cmpdetails` AS select `A`.`nama` AS `nama`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,`A`.`kwl1` AS `kwl1`,`A`.`kwl2` AS `kwl2`,`A`.`cmp1` AS `cmp1`,`A`.`cmp2` AS `cmp2`,`B`.`last` AS `last`,`B`.`kel` AS `kel`,`B`.`kec` AS `kec`,`B`.`kota` AS `kota`,`B`.`prov` AS `prov`,`A`.`no` AS `no`,`A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`B`.`kdkec` AS `kdkec`,`B`.`kdkota` AS `kdkota`,`B`.`kdprov` AS `kdprov`,`B`.`kpu_uri` AS `kpu_uri` from (`v11_tps_cmponly` `A` join `v04_kel_uri` `B` on((`A`.`kdkel` = `B`.`kdkel`)));

-- ----------------------------
-- View structure for v13_tps_sumcmp
-- ----------------------------
DROP VIEW IF EXISTS `v13_tps_sumcmp`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v13_tps_sumcmp` AS select sum(`v11_tps_cmponly`.`cmp1`) AS `cmp1`,sum(`v11_tps_cmponly`.`cmp2`) AS `cmp2`,count(0) AS `jumlah` from `v11_tps_cmponly`;

-- ----------------------------
-- View structure for v20_validate_kpu
-- ----------------------------
DROP VIEW IF EXISTS `v20_validate_kpu`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v20_validate_kpu` AS select `A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`A`.`nama` AS `nama`,`A`.`no` AS `no`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,ifnull(`A`.`kput`,0) AS `kput`,`A`.`kpus` AS `kpus`,`A`.`kpuj` AS `kpuj`,(`A`.`kpu1` + `A`.`kpu2`) AS `kpus_r`,((`A`.`kpu1` + `A`.`kpu2`) + ifnull(`A`.`kput`,0)) AS `kpuj_r`,`A`.`kpuimg` AS `kpuimg` from `t_tps` `A` where ((`A`.`kpu1` is not null) and (`A`.`kpu2` is not null));

-- ----------------------------
-- View structure for v21_validate_kpu_cmp
-- ----------------------------
DROP VIEW IF EXISTS `v21_validate_kpu_cmp`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v21_validate_kpu_cmp` AS select `A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`A`.`nama` AS `nama`,`A`.`no` AS `no`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,`A`.`kput` AS `kput`,`A`.`kpus` AS `kpus`,`A`.`kpuj` AS `kpuj`,`A`.`kpus_r` AS `kpus_r`,`A`.`kpuj_r` AS `kpuj_r`,(`A`.`kpus` - `A`.`kpus_r`) AS `kpus_c`,(`A`.`kpuj` - `A`.`kpuj_r`) AS `kpuj_c`,`A`.`kpuimg` AS `kpuimg` from `v20_validate_kpu` `A`;

-- ----------------------------
-- View structure for v22_invalid_kpu_detail
-- ----------------------------
DROP VIEW IF EXISTS `v22_invalid_kpu_detail`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v22_invalid_kpu_detail` AS select `A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`A`.`nama` AS `nama`,`A`.`no` AS `no`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,`A`.`kput` AS `kput`,`A`.`kpus` AS `kpus`,`A`.`kpuj` AS `kpuj`,`A`.`kpus_r` AS `kpus_r`,`A`.`kpuj_r` AS `kpuj_r`,`A`.`kpus_c` AS `kpus_c`,`A`.`kpuj_c` AS `kpuj_c`,`A`.`kpuimg` AS `kpuimg`,`B`.`kel` AS `kel`,`B`.`last` AS `last`,`B`.`kdkec` AS `kdkec`,`B`.`kec` AS `kec`,`B`.`kdkota` AS `kdkota`,`B`.`kota` AS `kota`,`B`.`kdprov` AS `kdprov`,`B`.`prov` AS `prov`,`B`.`kpu_uri` AS `kpu_uri` from (`v21_validate_kpu_cmp` `A` join `v04_kel_uri` `B` on((`A`.`kdkel` = `B`.`kdkel`))) where (((`A`.`kpus_c` <> 0) and (`A`.`kpus_c` is not null)) or ((`A`.`kpuj_c` <> 0) and (`A`.`kpuj_c` is not null)));

-- ----------------------------
-- View structure for v25_invalid_kpu_data_formatted
-- ----------------------------
DROP VIEW IF EXISTS `v25_invalid_kpu_data_formatted`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v25_invalid_kpu_data_formatted` AS select `A`.`prov` AS `propinsi`,`A`.`kota` AS `kabupanten_kota`,`A`.`kec` AS `kecamatan`,`A`.`kel` AS `kelurahan`,`A`.`nama` AS `tps`,`A`.`kpu1` AS `suara_01`,`A`.`kpu2` AS `suara_02`,`A`.`kput` AS `suara_tidaksah`,`A`.`kpus` AS `suara_sah`,`A`.`kpuj` AS `suara_total`,`A`.`kpus_r` AS `hitung_suara_sah`,`A`.`kpuj_r` AS `hitung_suara_total`,`A`.`kpus_c` AS `compare_suara_sah`,`A`.`kpuj_c` AS `compare_suara_total`,`A`.`last` AS `update_time`,concat('https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/',`A`.`kpu_uri`,'/',`A`.`kdtps`,'.json') AS `url_data`,concat('https://pemilu2019.kpu.go.id/img/c/',convert(substr(`A`.`kdtps`,1,3) using latin1),'/',convert(substr(`A`.`kdtps`,4,3) using latin1),'/',`A`.`kdtps`,'/',substr(`A`.`kpuimg`,1,(locate(';',`A`.`kpuimg`) - 1))) AS `img_pemilih`,concat('https://pemilu2019.kpu.go.id/img/c/',convert(substr(`A`.`kdtps`,1,3) using latin1),'/',convert(substr(`A`.`kdtps`,4,3) using latin1),'/',`A`.`kdtps`,'/',substr(`A`.`kpuimg`,(locate(';',`A`.`kpuimg`) + 1))) AS `img_suara`,`A`.`kdprov` AS `kdprov`,`A`.`kdkota` AS `kdkota`,`A`.`kdkec` AS `kdkec`,`A`.`kdkel` AS `kdkel`,`A`.`kdtps` AS `kdtps` from `v22_invalid_kpu_detail` `A`;

-- ----------------------------
-- View structure for v26_invalid_kpu_perprov
-- ----------------------------
DROP VIEW IF EXISTS `v26_invalid_kpu_perprov`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v26_invalid_kpu_perprov` AS select `A`.`kdprov` AS `kdprov`,`A`.`propinsi` AS `propinsi`,count(0) AS `jumlah_error`,sum(`A`.`suara_01`) AS `suara_01`,sum(`A`.`suara_02`) AS `suara_02`,sum(`A`.`suara_tidaksah`) AS `suara_tidaksah`,sum(`A`.`suara_sah`) AS `suara_sah`,sum(`A`.`suara_total`) AS `suara_total`,sum(`A`.`hitung_suara_sah`) AS `hitung_suara_sah`,sum(`A`.`hitung_suara_total`) AS `hitung_suara_total`,sum(abs(`A`.`compare_suara_sah`)) AS `compare_suara_sah`,sum(abs(`A`.`compare_suara_total`)) AS `compare_suara_total` from `v25_invalid_kpu_data_formatted` `A` group by `A`.`kdprov`;

-- ----------------------------
-- View structure for v30_kpupantau_cmp
-- ----------------------------
DROP VIEW IF EXISTS `v30_kpupantau_cmp`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v30_kpupantau_cmp` AS select `A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`A`.`nama` AS `nama`,`A`.`no` AS `no`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,`A`.`pnt1` AS `pnt1`,`A`.`pnt2` AS `pnt2`,ifnull((`A`.`kpu1` - `A`.`pnt1`),0) AS `cmp1`,ifnull((`A`.`kpu2` - `A`.`pnt2`),0) AS `cmp2` from `t_tps` `A` where ((`A`.`kpu1` is not null) and (`A`.`kpu2` is not null) and (`A`.`pnt1` is not null) and (`A`.`pnt2` is not null));

-- ----------------------------
-- View structure for v31_kpupantau_cmponly
-- ----------------------------
DROP VIEW IF EXISTS `v31_kpupantau_cmponly`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v31_kpupantau_cmponly` AS select `A`.`kdtps` AS `kdtps`,`A`.`kdkel` AS `kdkel`,`A`.`nama` AS `nama`,`A`.`no` AS `no`,`A`.`kpu1` AS `kpu1`,`A`.`kpu2` AS `kpu2`,`A`.`pnt1` AS `pnt1`,`A`.`pnt2` AS `pnt2`,`A`.`cmp1` AS `cmp1`,`A`.`cmp2` AS `cmp2` from `v30_kpupantau_cmp` `A` where ((`A`.`cmp1` <> 0) or (`A`.`cmp2` <> 0));

-- ----------------------------
-- View structure for v32_kpupantau_formatted
-- ----------------------------
DROP VIEW IF EXISTS `v32_kpupantau_formatted`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v32_kpupantau_formatted` AS select `B`.`prov` AS `propinsi`,`B`.`kota` AS `kab_kota`,`B`.`kec` AS `kecamatan`,`B`.`kel` AS `kelurahan`,`A`.`nama` AS `tps`,`A`.`kpu1` AS `kpu_pasangan_1`,`A`.`kpu2` AS `kpu_pasangan_2`,`A`.`pnt1` AS `pantau_pasangan_1`,`A`.`pnt2` AS `pantau_pasangan_2`,`A`.`cmp1` AS `selisih_pasangan_1`,`A`.`cmp2` AS `selisih_pasangan_2`,`B`.`last` AS `update_kpu`,`B`.`lastpnt` AS `update_pantau`,concat('https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/',`B`.`kpu_uri`,'/',`A`.`kdtps`,'.json') AS `url_json_kpu`,concat('https://pantau.kawalpilpres2019.id/',`B`.`kdprov`,'/',`B`.`kdkota`,'/',`B`.`kdkec`,'/',`B`.`kdkel`) AS `url_pantau`,`B`.`kdprov` AS `kdprov`,`B`.`kdkota` AS `kdkota`,`B`.`kdkec` AS `kdkec`,`A`.`kdkel` AS `kdkel`,`A`.`kdtps` AS `kdtps`,`A`.`no` AS `no` from (`v31_kpupantau_cmponly` `A` join `v04_kel_uri` `B` on((`A`.`kdkel` = `B`.`kdkel`)));

-- ----------------------------
-- View structure for v40_detail_data_tps
-- ----------------------------
DROP VIEW IF EXISTS `v40_detail_data_tps`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v40_detail_data_tps` AS select `B`.`prov` AS `propinsi`,`B`.`kota` AS `kabupanten_kota`,`B`.`kec` AS `kecamatan`,`B`.`kel` AS `kelurahan`,`A`.`nama` AS `tps`,`A`.`kpu1` AS `suara_01`,`A`.`kpu2` AS `suara_02`,`A`.`kput` AS `suara_tidaksah`,`A`.`kpus` AS `suara_sah`,`A`.`kpuj` AS `suara_total`,`B`.`last` AS `update_time`,concat('https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/',`B`.`kpu_uri`,'/',`A`.`kdtps`,'.json') AS `url_data`,concat('https://pemilu2019.kpu.go.id/img/c/',convert(substr(`A`.`kdtps`,1,3) using latin1),'/',convert(substr(`A`.`kdtps`,4,3) using latin1),'/',`A`.`kdtps`,'/',substr(`A`.`kpuimg`,1,(locate(';',`A`.`kpuimg`) - 1))) AS `img_pemilih`,concat('https://pemilu2019.kpu.go.id/img/c/',convert(substr(`A`.`kdtps`,1,3) using latin1),'/',convert(substr(`A`.`kdtps`,4,3) using latin1),'/',`A`.`kdtps`,'/',substr(`A`.`kpuimg`,(locate(';',`A`.`kpuimg`) + 1))) AS `img_suara`,`B`.`kdprov` AS `kdprov`,`B`.`kdkota` AS `kdkota`,`B`.`kdkec` AS `kdkec`,`B`.`kdkel` AS `kdkel`,`A`.`kdtps` AS `kdtps` from (`t_tps` `A` join `v04_kel_uri` `B` on((`A`.`kdkel` = `B`.`kdkel`)));

-- ----------------------------
-- View structure for v50_sum_data
-- ----------------------------
DROP VIEW IF EXISTS `v50_sum_data`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v50_sum_data` AS select (select count(0) from `t_tps`) AS `tps_total`,(select count(0) from `t_tps` where ((`t_tps`.`kpu1` is not null) or (`t_tps`.`kpu2` is not null))) AS `tps_masuk`,(select count(0) from `v25_invalid_kpu_data_formatted`) AS `tps_invalid`;

-- ----------------------------
-- View structure for v50_sum_data_persen
-- ----------------------------
DROP VIEW IF EXISTS `v50_sum_data_persen`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v50_sum_data_persen` AS select `A`.`tps_total` AS `tps_total`,`A`.`tps_masuk` AS `tps_masuk`,`A`.`tps_invalid` AS `tps_invalid`,((`A`.`tps_masuk` / `A`.`tps_total`) * 100) AS `persen_masuk`,((`A`.`tps_invalid` / `A`.`tps_masuk`) * 100) AS `persen_invalid` from `v50_sum_data` `A`;

SET FOREIGN_KEY_CHECKS = 1;
