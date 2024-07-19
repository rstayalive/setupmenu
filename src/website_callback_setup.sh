#!/bin/bash
#setup callback from website PJSIP version for freepbx

#funtion to wait ami user creation
wait()
{
echo -e "Please create ami manager user and set full permissions.\n You can do it at the freepbx web interface menu - Settings - asterisk manager users.\n
 If you ready to continue press any key."
read -s -n 1
}
wait
#collect ami credentials and asterisk IP
read -p "enter external/localhost Asterisk IP address: " AIP
read -p "enter asterisk ami manager username: " amilogin
read -p "enter asterisk ami manager password for user $amilogin: " amipassword
read -p "enter extension or ring-group/queue number for incoming calls from website: " extension

# Function to validate time input
validate_time() {
    if [[ ! "$1" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
        echo "Invalid time format. Please use HH:MM in 24-hour format."
        return 1
    fi
    return 0
}

# Prompt user for start time
while true; do
    read -p "Enter start time for website calls (HH:MM, 24-hour format) Example 9:00: " start_time
    if validate_time "$start_time"; then
        break
    fi
done

# Prompt user for end time
while true; do
    read -p "Enter end time for website calls (HH:MM, 24-hour format) Example 19:00: " end_time
    if validate_time "$end_time"; then
        break
    fi
done
cpath='/var/www/html/website_callback.php'
hpath='/var/www/html/websitecallform.html'
#copying callback php template
cp /root/setupmenu/src/website_callback.php /var/www/html/
#setting parameters to website_callback.php
replace "your.freepbx.ip" "$AIP" -- $cpath
replace "your_ami_username" "$amilogin" -- $cpath
replace "your_ami_password" "$amipassword" -- $cpath
replace "start_time" "$start_time" -- $cpath
replace "end_time" "$end_time" -- $cpath
replace "incomingextension" "$extension" -- $cpath

#changing user for website_callback.php file
chown asterisk:asterisk $cpath
#adding context for callback to /etc/asterisk/extensions_custom.conf
echo "
[custom-outbound]
exten => _X.,1,NoOp(Outbound call to ${EXTEN})
exten => _X.,n,Dial(PJSIP/${EXTEN}@outbound-allroutes,30)
exten => _X.,n,Hangup()" >> /etc/asterisk/extensions_custom.conf

#touch html form to test calls
echo "
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Request a Callback</title>
</head>
<body>
    <h1>Request a Callback</h1>
    <form action="website_callback.php" method="post">
        <label for="callerid">Enter your phone number:</label>
        <input type="text" id="callerid" name="callerid" required>
        <button type="submit">Request Callback</button>
    </form>
</body>
</html>" >> $hpath
#changing user for websitecallform.html file
chown asterisk:asterisk $hpath
echo "All settings done"