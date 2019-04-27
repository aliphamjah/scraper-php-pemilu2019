<?php

$kdprovz=$argv[1];
if (!$kdprovz){
  echo "ARGV1 = Kode Propinsi\n";
  exit();
}

include_once 'libs/db.php';

function start_prov($kdprov){
  echo "* PROV {$kdprov}\n";
  $kotas=wget("https://pemilu2019.kpu.go.id/static/json/wilayah/{$kdprov}.json");
  $sql=array();
  $kota=array();
  $kota_url=array();
  $kdkotas=array();
  foreach ($kotas as $kdkota=>$kota){
    $sql[]=
      "(".
        "'".esc($kdkota)."',".
        "'".esc($kdprov)."',".
        "'".esc($kota['nama'])."'".
      ")";
    $kota_url[]="https://pemilu2019.kpu.go.id/static/json/wilayah/{$kdprov}/{$kdkota}.json";
    $kdkotas[]=$kdkota;
  }
  query("INSERT INTO `t_kota` VALUES\n  ".implode(",",$sql));

  $kdkecs=array();
  $kec_url=array();
  echo "  * Download Kecamatan ";
  $kecs = wgets($kota_url);
  echo "\n";
  $sql=array();
  for ($i=0;$i<count($kecs);$i++){
    $kdkota=$kdkotas[$i];
    $kdkecs[$i]=array();
    $kec_url[$i]=array();
    foreach($kecs[$i] as $kdkec=>$kec){
      $sql[]=
        "(".
          "'".esc($kdkec)."',".
          "'".esc($kdkota)."',".
          "'".esc($kec['nama'])."'".
        ")";
      $kec_url[$i][]="https://pemilu2019.kpu.go.id/static/json/wilayah/{$kdprov}/{$kdkota}/{$kdkec}.json";
      $kdkecs[$i][]=$kdkec;
    }
  }
  query("INSERT INTO `t_kec` VALUES\n  ".implode(",",$sql));

  for ($n=0;$n<count($kec_url);$n++){
    printf("%10s ",$kdkotas[$n]);
    $kels = wgets($kec_url[$n]);
    $sql=array();
    for ($i=0;$i<count($kels);$i++){
      $kdkec=$kdkecs[$n][$i];
      foreach($kels[$i] as $kdkel=>$kel){
        $sql[]=
          "(".
            "'".esc($kdkel)."',".
            "'".esc($kdkec)."',".
            "'".esc($kel['nama'])."',NULL".
          ")";
      }
    }
    echo " (".count($sql).")\n";
    query("INSERT INTO `t_kel` VALUES\n  ".implode(",",$sql));
  }
}


$PRV=explode(",",$kdprovz);
for ($PP=0;$PP<count($PRV);$PP++){
  start_prov($PRV[$PP]);
}

// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp.json >> data
// https://pemilu2019.kpu.go.id/static/json/ppwp.json >> Calon
// https://pemilu2019.kpu.go.id/static/json/wilayah/0.json >> dapil


// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1654/1656.json >> data

// https://pemilu2019.kpu.go.id/static/json/wilayah/1/2/9/10.json >> wilayah

// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1672/1697.json

// https://pemilu2019.kpu.go.id/static/json/wilayah/1/1492/1654.json

// https://pemilu2019.kpu.go.id/static/json/wilayah/12920/13608/83415/87532.json
// https://pemilu2019.kpu.go.id/static/json/wilayah/12920/13608/83415/87532.json
?>