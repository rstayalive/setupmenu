<?php
// Configuration
$asterisk_ip = 'your.freepbx.ip';
$asterisk_username = 'your_ami_username';
$asterisk_password = 'your_ami_password';
$log_file = 'callback_log.txt';

// Function to log messages
function log_message($message) {
    global $log_file;
    file_put_contents($log_file, date('Y-m-d H:i:s') . " - " . $message . "\n", FILE_APPEND);
}

// Get the caller ID from the form submission
$callerid = $_POST['callerid'];

// Validate and sanitize the caller ID
$callerid = preg_replace("/[^0-9]/", "", $callerid);

if (strlen($callerid) != 11) {
    log_message("Invalid phone number: $callerid. Must be 11 digits.");
    echo "Invalid phone number. Must be 11 digits.";
    exit;
}

// Set timezone to Europe/Moscow
date_default_timezone_set('Europe/Moscow');

// Check if the current time is within the allowed hours
//$current_hour = date('H');
//if ($current_hour < 9 || $current_hour >= 19) {
//    log_message("Callback request outside allowed hours: $current_hour.");
//    echo "Callback requests are only allowed between 09:00 and 19:00.";
//    exit;
//}

// Connect to Asterisk Manager Interface (AMI)
$socket = fsockopen($asterisk_ip, 5038, $errno, $errstr, 30);
if (!$socket) {
    log_message("Error connecting to AMI: $errstr ($errno)");
    echo "Error connecting to AMI: $errstr ($errno)";
    exit;
}

fputs($socket, "Action: Login\r\n");
fputs($socket, "Username: $asterisk_username\r\n");
fputs($socket, "Secret: $asterisk_password\r\n\r\n");

$response = fgets($socket, 128);
if (strpos($response, 'Success') === false) {
    log_message("AMI login failed: $response");
    echo "AMI login failed.";
    fclose($socket);
    exit;
}

// Send Originate command
fputs($socket, "Action: Originate\r\n");
fputs($socket, "Channel: Local/$callerid@from-internal\r\n");
fputs($socket, "Context: callback\r\n");
fputs($socket, "Exten: $callerid\r\n");
fputs($socket, "Priority: 1\r\n");
fputs($socket, "Callerid: Callback <$callerid>\r\n\r\n");

$response = fgets($socket, 128);
if (strpos($response, 'Success') === false) {
    log_message("Originate command failed: $response");
    echo "Originate command failed.";
    fclose($socket);
    exit;
}

// Logoff from AMI
fputs($socket, "Action: Logoff\r\n\r\n");
fclose($socket);

log_message("Callback triggered for $callerid.");
echo "Callback triggered.";
?>