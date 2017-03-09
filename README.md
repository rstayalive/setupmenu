# setupmenu
FreePBX deployment script

Language: only RU

Script work with FreePBX 11/13 CentOS 6.X under root

usage:
1. cd /root
2. yum install git
3. git clone https://github.com/rstayalive/setupmenu
4. cd setupmenu
5. chmod 777 setupmenu.sh
6. ./setupmenu

Main Menu:
1. Integration

1) Install module Vedisoft(Prostiezvonki) versions for asterisk 11/13 x86_64
2) Recreate certificate for Prostiezvonki
3) Install edited cel.conf for Prostiezvonki
4) Install web callback conf file to /var/www/html
5) Install click2call chrome extension config file to /var/www/html
0) Exit to main menu

2. Settings

1) Setup system autoupdate for linux
2) Disable FreeBPX actually not used modules
3) Update freepbx version
4) Postfix config (FreePBX will send emails from gmail acc)
0) Exit to main menu

3. Additional

1) Configure report about missed calls for this day
2) Setup AsternicCDR module to FreePBX
3) Configure ivr missed calls to email
0) Exit to main menu

4. Security

1) Remove Firewall module from FreePBX
2) Setup xtables GeoIP module for iptables
3) Flush iptables rules
4) Add to iptables standart FreePBX rules
5) Add to iptables extended security rules
6) Add IP/NET to iptables allow rules
7) Ddd Port/Port-Range to iptables allow rules
8) Save iptables changes
9) List current iptables rules
0) Exit to main menu

5. Empty (Reserved for future)
6. Empty (Reserved for future)

7. Setup additional software
mc,mtr,iotop,lm-sensors,nmap,git,gcc,sngrep

8. Release Notes
9. Update script
0. Exit
