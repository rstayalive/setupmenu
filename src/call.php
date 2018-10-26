<?php
$rdomain=$_SERVER['ORIGIN'];
if(!$rdomain) $rdomain='*';
header("Access-Control-Allow-Origin: ".$rdomain);
header("Access-Control-Allow-Methods: GET,POST,OPTIONS");
$strHost = "asteriskip";
$strUser = "callback";
$strSecret = "TQXhW9tAQxM8";
$strChannel = "Local/100@from-internal";
$strExten = $_POST['txtphonenumber'];
$strExten=preg_replace("/[^01-9]/","",$strExten);

if (strlen($strExten) == 11 && is_numeric($strExten))
{
$socket = fsockopen($strHost, 5038, $errnum, $errdesc) or die("Connection to host failed");
fputs($socket, "Action: login\r\n");
fputs($socket, "Username: $strUser\r\n");
fputs($socket, "Secret: $strSecret\r\n\r\n");
sleep (1);

fputs($socket, "Action: Originate\r\n" );
fputs($socket, "Channel: Local/999@from-internal\r\n" );
fputs($socket, "Context: from-internal\r\n" );
fputs($socket, "Exten: $strExten\r\n" );
fputs($socket, "Timeout: 30000\r\n" );
fputs($socket, "Callerid: $strExten\r\n");
fputs($socket, "Priority: 1\r\n" );
fputs($socket, "Async: yes\r\n\r\n" );
fputs($socket, "Action: Logoff\r\n\r\n");
sleep (1);
$wrets=fgets($socket,128);
echo "calling...";
}else{
	echo "ERROR -".strlen($strExten)."-";
}
