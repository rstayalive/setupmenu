<?php
// Database connection
//$link = mysqli_connect("localhost", "report", "2yCg6e8r5ng");
//mysqli_select_db($link, "asteriskcdrdb");

// Get the current date and time
$today = date('Y-m-d');
$data = date('d-m-Y H:i:s');

// Sanitize and validate the caller ID
$callerid = isset($_POST['callerid']) ? preg_replace("/[^0-9]/", "", $_POST['callerid']) : "";
if (strlen($callerid) != 11) {
    die("Invalid phone number. Must be 11 digits.");
}

// Set the timezone
date_default_timezone_set('Europe/Moscow');

// Ensure calls are only placed between 09:00 and 19:00
$current_time = date('H:i:s');
if ($current_time < 'start_time' || $current_time > 'end_time') {
    die("Calls can only be placed between 09:00 and 19:00 Moscow time.");
}

// AMI credentials
$ami_host = 'your.freepbx.ip';
$ami_port = 5038;
$ami_user = 'your_ami_username';
$ami_secret = 'your_ami_password';

// Create AMI connection
$socket = fsockopen($ami_host, $ami_port, $errno, $errstr, 30);
if (!$socket) {
    die("Unable to connect to AMI: $errstr ($errno)");
}

// Authenticate
fwrite($socket, "Action: Login\r\n");
fwrite($socket, "Username: $ami_user\r\n");
fwrite($socket, "Secret: $ami_secret\r\n");
fwrite($socket, "Events: off\r\n\r\n");

$response = '';
while (!feof($socket)) {
    $response .= fgets($socket, 4096);
    if (strpos($response, "\r\n\r\n") !== false) {
        break;
    }
}

if (strpos($response, 'Success') === false) {
    log_message("AMI login failed: $response");
    echo "AMI login failed.";
    fclose($socket);
    exit;
}

// Function to send an AMI command
function sendAmiCommand($socket, $command) {
    fwrite($socket, $command . "\r\n\r\n");
    return fread($socket, 4096);
}

// Initiate the callback
$context = 'custom-outbound';
$extension = 'incomingextension'; // Internal extension to ring

// Call user phone number
$command1 = "Action: Originate\r\n";
$command1 .= "Channel: Local/$callerid@$context\r\n";
$command1 .= "Context: from-internal\r\n";
$command1 .= "Exten: $extension\r\n";
$command1 .= "Priority: 1\r\n";
$command1 .= "CallerID: $callerid\r\n";
$command1 .= "Timeout: 30000\r\n";
$response1 = sendAmiCommand($socket, $command1);

// Call internal extension
$command2 = "Action: Originate\r\n";
$command2 .= "Channel: Local/$extension@from-internal\r\n";
$command2 .= "Context: from-internal\r\n";
$command2 .= "Exten: $extension\r\n";
$command2 .= "Priority: 1\r\n";
$command2 .= "CallerID: $callerid\r\n";
$command2 .= "Timeout: 30000\r\n";
$response2 = sendAmiCommand($socket, $command2);

// Close AMI connection
fwrite($socket, "Action: Logoff\r\n\r\n");
fclose($socket);

// Output results
echo "Callback initiated to $callerid and extension $extension<br>";
echo "Response from AMI:<br>";
echo "<pre>$response1</pre>";
echo "<pre>$response2</pre>";
?>