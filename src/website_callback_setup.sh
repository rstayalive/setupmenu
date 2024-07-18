#!/bin/bash
#collect credentials and asterisk IP
read -p "enter external Asterisk IP address" AIP
read -p "enter asterisk ami manager username" amilogin
read -p "enter asterisk ami manager password for user: $amilogin" amipassword

cpath='/var/www/html/website_callback.php'
cp /root/setupmenu/src/website_callback.php /var/www/html/

replace "your.freepbx.ip" "$AIP" -- $cpath
replace "your_ami_username" "$amilogin" -- $cpath
replace "your_ami_password" "$amipassword" -- $cpath

echo -e"\n
[callback]
exten => _X.,1,NoOp(Callback from website)
same => n,Set(CALLERID(num)=${EXTEN})
same => n,Playback(silence/1)  ; Optional, for 1 second of silence
same => n,Hangup()" >> /etc/asterisk/extensions_custom.conf