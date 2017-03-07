<?php
        $num = $_REQUEST['phone'];
        $ext = $_REQUEST['exten'];
        $num = preg_replace( "/^\+7/", "8", $num );
        $num = preg_replace( "/\D/", "", $num );
 	echo "$num\r\n";
	echo "$ext\r\n";
	$strHost = "asteriskip";
	$strUser = "callback";
	$strSecret = "TQXhW9tAQxM8";

        if ( ! empty( $num ) )
        {
                echo "Dialing $num\r\n";
 
		$socket = fsockopen($strHost, 5038, $errnum, $errdesc) or die("Connection to host failed");
		fputs($socket, "Action: login\r\n");
		fputs($socket, "Username: $strUser\r\n");
		fputs($socket, "Secret: $strSecret\r\n\r\n");
		sleep (1);
 
                $wrets=fgets($socket,128);
 
                echo $wrets;
 
		fputs($socket, "Action: Originate\r\n" );
		fputs($socket, "Channel: Local/$ext@from-internal\r\n" );
		fputs($socket, "Callerid: $num\r\n");
		fputs($socket, "Exten: $num\r\n" );
		fputs($socket, "Timeout: 20000\r\n" );
		fputs($socket, "Context: from-internal\r\n" );
		fputs($socket, "Priority: 1\r\n" );
		fputs($socket, "Async: yes\r\n\r\n" );
		fputs($socket, "Action: Logoff\r\n\r\n");
		sleep (1);
 
                $wrets=fgets($socket,128);
                echo $wrets;
        }
        else
        {
                echo "Unable to determine number from (" . $_REQUEST['phone'] . ")\r\n";
        }
?>