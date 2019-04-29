<?php

ini_set('display_errors','On');
ini_set('error_reporting',E_ALL&~E_NOTICE);
include_once 'libs/db.php';

function vchk($k){
  if (($k)||($k===0)||($k==='0')){
    return true;
  }
  else{
    return false;
  }
}
function vesc($k){
  if (($k)||($k===0)||($k==='0')){
    return "'".esc($k)."'";
  }
  else{
    return 'NULL';
  }
}
function start_suara($kdkels){
  global $mysqli;
  $all_uris=array();
  
  for ($i=0;$i<count($kdkels);$i++){
    $kdkel=$kdkels[$i];
    $all_uris[]="https://pantau.kawalpilpres2019.id/api/tps-{$kdkel}.json"; /* PANTAU VALUE */
    // 
  }
  
  echo "* Kel(".($kdkels[0])."-".($kdkels[count($kdkels)-1]).") ";
  $suara=wgets($all_uris);
  $uq=array();
  for ($i=0;$i<count($suara);$i++){
    $kdkel=$kdkels[$i];
    for ($j=0;$j<count($suara[$i]);$j++){
      $d=$suara[$i][$j];
      if (vchk($d['jokowi_amin'])&&vchk($d['prabowo_sandi'])){
        $q="UPDATE `t_tps` SET";
        $q.=  " `pnt1`=".vesc($d['jokowi_amin']);
        $q.=  ",`pnt2`=".vesc($d['prabowo_sandi']);
        $q.=" WHERE `kdkel`='{$kdkel}' AND `no`='{$d['nama_wilayah']}'";
        $uq[]=$q;
        echo "+";
      }
    }
    $uq[]="UPDATE `t_kel` SET `lastpnt`=NOW() WHERE `kdkel`='{$kdkel}'";
  }
  echo "\n";
  if (count($uq)>0){
    $sqls=implode(";\n",$uq);
    $mysqli->multi_query($sqls);
    while($mysqli->more_results()){
       $mysqli->next_result();
    }
  }
}

while(true){
  $rows=all("SELECT `kdkel` FROM `v03_kel` ORDER BY `lastpnt` ASC LIMIT 0,50");
  $kodes=array();
  for ($i=0;$i<count($rows);$i++){
    $kodes[]=$rows[$i]['kdkel'];
  }
  start_suara($kodes);
  usleep(100000);
}


?>