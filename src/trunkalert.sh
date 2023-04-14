#!/bin/bash
#setup trunk failure script

wget -O /var/lib/asterisk/agi-bin/trunkalert.agi https://raw.githubusercontent.com/sorvani/freepbx-helper-scripts/master/Monitor_Trunk_Failure/trunkalert.agi

replace "yourpbxemail@domain.com" "asterisk.delivery@gmail.com" -- /var/lib/asterisk/agi-bin/trunkalert.agi
replace "alertemail@domain.com" "support@planfix.rsloc.ru" -- /var/lib/asterisk/agi-bin/trunkalert.agi

chown asterisk:asterisk /var/lib/asterisk/agi-bin/trunkalert.agi
fwconsole chown