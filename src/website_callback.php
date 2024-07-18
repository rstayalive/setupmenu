<?php
// Configuration
$asterisk_ip = 'your.freepbx.ip';
$asterisk_username = 'your_ami_username';
$asterisk_password = 'your_ami_password';
$callerid = $_POST['callerid'];

// Validate and sanitize the caller ID
$callerid = preg_replace("/[^0-9]/", "", $callerid);

if (strlen($callerid) != 11) {
    echo "Invalid phone number. Must be 11 digits.";
    exit;
}

// Set timezone to Europe/Moscow
date_default_timezone_set('Europe/Moscow');

// Check if the current time is within the allowed hours
$current_hour = date('H');
if ($current_hour < 1 || $current_hour >= 23) {
    echo "Callback requests are only allowed between 09:00 and 19:00.";
    exit;
}

// Connect to Asterisk Manager Interface (AMI)
$socket = fsockopen($asterisk_ip, 5038, $errno, $errstr, 30);
if (!$socket) {
    echo "$errstr ($errno)<br />\n";
    exit;
}

fputs($socket, "Action: Login\r\n");
fputs($socket, "Username: $asterisk_username\r\n");
fputs($socket, "Secret: $asterisk_password\r\n\r\n");

fputs($socket, "Action: Originate\r\n");
fputs($socket, "Channel: Local/$callerid@from-internal\r\n");
fputs($socket, "Context: callback\r\n");
fputs($socket, "Exten: $callerid\r\n");
fputs($socket, "Priority: 1\r\n");
fputs($socket, "Callerid: Callback <$callerid>\r\n\r\n");

fputs($socket, "Action: Logoff\r\n\r\n");
fclose($socket);

echo "Callback triggered.";
?>
