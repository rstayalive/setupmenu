<?php
$link = mysql_connect("localhost", "report", "2yCg6e8r5ng");
mysql_select_db("asteriskcdrdb", $link);
$today = date('y-m-d');
$data = date('d-m-Y H:i:s');
$email = "myemail";
echo "NO ANSWERED ---------------------------------<br>";

$result = mysql_query("select src, calldate from cdr where disposition = 'NO ANSWER' and calldate >='$today 00:00:00' and calldate <='$today 23:59:59' and duration >10 and LENGTH(src) >3;", $link);
$counter=1;

while ($row = mysql_fetch_array($result, MYSQL_NUM)) {
	
	$noansw[$counter]=$row[0];
        $calldate[$counter]=$row[1];
        echo "$noansw[$counter]<br>";
	$counter = $counter + 1;
}

echo "ANSWERED ---------------------------------<br>";

$result = mysql_query("select src, calldate from cdr where disposition = 'ANSWERED' and calldate >='$today 00:00:00' and calldate <='$today 23:59:59' and LENGTH(src) >3;", $link);
$counter=1;
while ($row = mysql_fetch_array($result, MYSQL_NUM)) {

        $answ[$counter]=$row[0];
        echo "$answ[$counter]<br>";
        $counter = $counter + 1;

}
echo "DELETE ANWERED ---------------------------------<br>";

$total = count($noansw);
$counter1 = 0;
foreach($noansw as $key1 => $value1){
  $counter1++;
  if($counter1 <= $total){
	$total = count($answ);
	$counter2 = 0;
	foreach($answ as $key2 => $value2){
	  $counter2++;
	  if($counter2 <= $total){
		if ($noansw[$counter1] == $answ[$counter2]) {
   		        echo "delete $noansw[$counter1]<br>";
			$noansw[$counter1]='';
		}
	  }
	}
  }
}

$headers = "Content-type: text/html; charset=utf-8 \r\n"; //заголовок для письма
$headers .= "From: asterisk.maildelivery@gmail.com \r\n"; 
$headers .= "Reply-To: asterisk.maildelivery@gmail.com \r\n";

$mes .= ' 
<table style="max-width: 575px;border-bottom:none; margin: 0 auto;border-spacing: inherit;">
<thead>
<tr style="border-bottom: 2px solid #05477c;">
<th style="padding:10px; color: #fff; max-width: 150px;background:#05477c;">Порядковый номер</th>
<th style="padding:10px; color: #fff; max-width: 150px;background:#05477c;">Дата</th>
<th style="padding:10px; color: #fff; max-width: 100px;background:#05477c;">От кого</th>

</tr>
</thead>';


echo "RESULT ---------------------------------<br>";

$total = count($noansw);
$counter = 0;
$counter3 = 0;
$propcount = 0;

foreach($noansw as $key => $value){
  $counter++;
  if($counter <= $total){
	if ($noansw[$counter] != '') {
		$counter3++;
		 echo "$noansw[$counter]<br>";
		$mes .= '	
		<tbody>
		<tr style="width: 100px;">
		<td style="padding:10px;  border-bottom: 1px solid #eee; text-align:center;">' . $counter3.'</td>
		<td style="padding:10px;  border-bottom: 1px solid #eee; text-align:center;min-width: 100px;">' . $calldate[$counter].'</td>
		<td style="padding:10px;  border-bottom: 1px solid #eee; text-align:center;min-width: 100px;">' . $noansw[$counter].'</td>
		</tr>
		</thead>';
	}
  }
}

if ($counter3 > 0) {
mail("$email", 'Пропущенные звонки за  ' .$data.'', $mes, $headers);
echo "No Answer Count = $counter3<br>";
}
else
{
echo "Netu NoAnswer<br>";
}


?>
