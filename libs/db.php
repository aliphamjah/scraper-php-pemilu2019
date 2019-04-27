<?php

ob_implicit_flush(true);
set_time_limit(0);

$mysqli = new mysqli(
	"127.0.0.1",
	"root",
	"password",
	"dbkawal"
);

function query($str){
  global $mysqli;
	return $mysqli->query($str);
}
function sql($str){
  global $mysqli;
	if ($result=query($str)){
		$r=@$result->fetch_assoc();
		$result->close();
		return $r;
	}
	else 
		return false;
}
function all($str){
  global $mysqli;
  $RET=array();
	if ($result=query($str)){
		while ($RETT=@$result->fetch_assoc()){
			$RET[]=$RETT;
		}
		$result->close();
	}
	return $RET;
}
function num($str){
  global $mysqli;
	$res = query($str);
	if (!$res) return 0;
	return mysqli_num_rows($res);
}
function qnum($q){
  global $mysqli;
	if (!$q) return 0;
	return mysqli_num_rows($q);
}
function err(){
  global $mysqli;
	return $mysqli->error;
}
function slash($str){
  global $mysqli;
	return $mysqli->real_escape_string($str);
}
function esc($str){
  global $mysqli;
	return $mysqli->real_escape_string($str);
}
function enc($str){
  global $mysqli;
  return $mysqli->real_escape_string(gzencode($str, 9));
}


function www_init($url){
  $ch = curl_init ();
	curl_setopt ( $ch, CURLOPT_URL, $url);
	curl_setopt ( $ch, CURLOPT_SSL_VERIFYHOST, 0);
	curl_setopt ( $ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt ( $ch, CURLOPT_RETURNTRANSFER,true);
	return $ch;
}

function www_get($url) {
	$ch=www_init($url);
	$out=curl_exec($ch);
	curl_close($ch);
	return $out;
}

function www_gets($urls){
  $chs=array();
  $mh = curl_multi_init();
  for ($i=0;$i<count($urls);$i++){
    $chs[$i]=www_init($urls[$i]);
    curl_multi_add_handle($mh,$chs[$i]);
  }
  $n=0;
  do {
    $status = curl_multi_exec($mh, $active);
    if ($active) {
      if (++$n>5){
        echo ".";
        $n=0;
      }
      curl_multi_select($mh);
    }
  } while ($active && $status == CURLM_OK);
  $out=array();
  for ($i=0;$i<count($chs);$i++){
    curl_multi_remove_handle($mh,$chs[$i]);
  }
  curl_multi_close($mh);
  for ($i=0;$i<count($chs);$i++){
    $out[$i]=curl_multi_getcontent($chs[$i]);
  }
  return $out;
}

function wget($url){
  $out="";
  do{
    $out=www_get($url);
  }while(!$out);
  return json_decode($out,true);
}

function wgets($urls){
  $out=array();
  $outs=www_gets($urls);
  for ($i=0;$i<count($urls);$i++){
    if (!$outs[$i]){
      $out[$i]=wget($urls[$i]);
    }
    else{
      $out[$i]=json_decode($outs[$i],true);
    }
  }
  return $out;
}

?>