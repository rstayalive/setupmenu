#!/bin/bash
#new security configuration script work with default FPBX firewall module and Fail2ban.
#beta 0.0.1 not use now at production server, please test before on VM

#
echo -e "\nPress enter your local network subnet 192.168.0.0/24"
read localnet ;

#cheking firewall module installed and enabled
FWM=$(fwconsole ma list | grep "firewall" | grep "Enabled")
	if [ "$FWM" == "Enabled" ];
		then
        echo "enabled"
        else
        echo "disabled:
        fi
fwconsole firewall add trusted $localnet
fwconsole firewall add trusted 176.192.230.26 
fwconsole firewall add trusted ip.kurskhelp.ru
fwconsole firewall lerules enable
fwconsole firewall sync
fwconsole firewall restart