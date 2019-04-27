<?php

ini_set('display_errors','On');
ini_set('error_reporting',E_ALL&~E_NOTICE);
include_once 'libs/db.php';

function vesc($k){
  if (($k)||($k===0)||($k==='0')){
    return "'".esc($k)."'";
  }
  else{
    return 'NULL';
  }
}
function start_suara($uris){
  global $mysqli;
  $kdkels=array();
  $all_uris=array();
  
  for ($i=0;$i<count($uris);$i++){
    $uri=$uris[$i];
    $uuri=explode("/",$uri);
    $kdkels[]=$kdkel=$uuri[3];
    $all_uris[]="https://pemilu2019.kpu.go.id/static/json/wilayah/{$uri}.json"; /* KPU WILAYAH */
    $all_uris[]="https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/{$uri}.json"; /* KPU SUARA */
    // $all_uris[]="https://kawal-c1.appspot.com/api/c/{$kdkel}"; /* kawalpemilu.org */
  }
  
  echo "* Kel(".($kdkels[0])."-".($kdkels[count($kdkels)-1]).") ";
  $suara=wgets($all_uris);
  echo "\n  ## TPS ";
  $n=0;
  $out = array();
  $iq=array();
  $uq=array();
  for ($i=0;$i<count($suara);$i+=2){
    $tpsurls=array();
    $tpsurlid=array();
    $tpql=array();
    $mm=0;
    foreach($suara[$i] as $kode=>$tps){
      $urlupdate="https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/{$uris[$n]}/{$kode}.json";
      $k = (int) substr($tps['nama'],4);
      $iq[] = "(".
        "'".esc($kode)."',".
        "'".esc($kdkels[$n])."',".
        "'".esc($tps['nama'])."',".
        "'".esc($k."")."'".
      ")";
      $q="UPDATE `t_tps` SET";
        $q.=" `kpu1`=".vesc($suara[$i+1]['table'][$kode][21]);
        $q.=",`kpu2`=".vesc($suara[$i+1]['table'][$kode][22]);
        /*
        if (isset($suara[$i+2]['data'][$k])){
          $q.=",`kwl1`=".vesc($suara[$i+2]['data'][$k]['sum']['pas1']);
          $q.=",`kwl2`=".vesc($suara[$i+2]['data'][$k]['sum']['pas2']);
        }
        */
      $tpql[$mm]=array(
        $q,
        "",
        " WHERE `kdtps`='{$kode}'"
      );
      
      if ((!is_null($suara[$i+1]['table'][$kode][21]))||(!is_null($suara[$i+1]['table'][$kode][22]))){
        $tpsurls[]=$urlupdate;
        $tpsurlid[]=$mm;
        echo "+";
      }
      else{
        $uq[]=implode("",$tpql[$mm]);
        echo "x";
      }
      $mm++;
    }
    
    if (count($tpsurls)>0){
      $tpss=wgets($tpsurls);
      for ($j=0;$j<count($tpss);$j++){
        $pss=$tpss[$j];
        $q="";
        $q.=",`kput`=".vesc($pss['suara_tidak_sah']);
        $q.=",`kpus`=".vesc($pss['suara_sah']);
        $q.=",`kpuj`=".vesc($pss['suara_total']);
        if ($pss['images']){
          $q.=",`kpuimg`=".vesc(implode(";",$pss['images']));
        }
        $tpql[$tpsurlid[$j]][1]=$q;
        $uq[]=implode("",$tpql[$j]);
      }
    }
    
    $uq[]="UPDATE `t_kel` SET `last`=NOW() WHERE `kdkel`='{$kdkels[$n]}'";
    $n++;
  }
  echo "\n";
  
  if (count($iq)>0){
    query("INSERT INTO `t_tps` (`kdtps`,`kdkel`,`nama`,`no`) VALUES ".implode(",",$iq));
  }
  if (count($uq)>0){
    $sqls=implode(";\n",$uq);
    $mysqli->multi_query($sqls);
    while($mysqli->more_results()){
       $mysqli->next_result();
    }
  }
}

/*
start_suara(array(
  "1/1492/1654/1656",
  "1/2/9/10"
));
*/

$kdprovz=$argv[1];
if (!$kdprovz){
  echo "ARGV1 = Kode Propinsi\n";
  exit();
}

$PRV=explode(",",$kdprovz);

// for ($JJ=0;$JJ<4;$JJ++){
while(true){
  for ($PP=0;$PP<count($PRV);$PP++){
    $rows=all("SELECT `kpu_uri` FROM `v04_kel_uri` WHERE `kdprov`='{$PRV[$PP]}' ORDER BY `last` ASC LIMIT 0,10");
    $urls=array();
    for ($i=0;$i<count($rows);$i++){
      $urls[]=$rows[$i]['kpu_uri'];
    }
    start_suara($urls);
  }
}



// https://kawal-c1.appspot.com/api/c/931268 (KODE KELURAHAN)

// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp.json >> data
// https://pemilu2019.kpu.go.id/static/json/ppwp.json >> Calon
// https://pemilu2019.kpu.go.id/static/json/wilayah/0.json >> dapil

// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1493/1501.json
// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1493/1501/900003213.json



// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1654/1656.json >> data

// https://pemilu2019.kpu.go.id/static/json/wilayah/1/2/9/10.json >> wilayah

// https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/1/1492/1672/1697.json

// https://pemilu2019.kpu.go.id/static/json/wilayah/1/1492/1654.json

// https://pemilu2019.kpu.go.id/static/json/wilayah/12920/13608/83415/87532.json
// https://pemilu2019.kpu.go.id/static/json/wilayah/12920/13608/83415/87532.json
?>