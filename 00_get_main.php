<?php

include_once 'libs/db.php';
$provs=wget("https://pemilu2019.kpu.go.id/static/json/wilayah/0.json");

$sql=array();
foreach ($provs as $kdprov=>$prov){
  $sql[]=
    "(".
      "'".esc($kdprov)."',".
      "'".esc($prov['nama'])."'".
    ")";
}
$sql_all = "INSERT INTO `t_prov` VALUES\n  ".implode(",\n  ",$sql);
query($sql_all);
echo $sql_all."\n";

?>