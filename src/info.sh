#!/bin/bash
#asterisk info gather script
end()
{
echo -e "файл с иформацией лежит $out, нажмите любую кнопку для продолжения"
read -s -n 1
}
arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64
else arc=86
fi
astver=$(asterisk -V | grep -woE [0-9]+\.)
ami=$(asterisk -rx 'manager show settings')
cel=$(asterisk -rx 'cel show status')
celcheck=$(mysql asteriskcdrdb --execute="SELECT id, eventtype, eventtime, cid_num, exten, uniqueid, linkedid, channame from cel order by id desc limit 10" ;)
cdrcheck=$(mysql asteriskcdrdb --execute="SELECT recordingfile from cdr order by calldate desc limit 10" ;)
phpver=$(php -v)
phpjson=$(php -r 'var_dump(function_exists("json_decode"));')
phpcurl=$(php -r 'echo curl_version()["version"];')
out="/tmp/outputinfo.txt"
uname=`uname -r`
red=`cat /etc/redhat-release`
deb=`cat /etc/debian_version`
pbxfirm=`cat /etc/schmooze/pbx-version`
ip=`fwconsole extip`
freepbx=`rpm -qa | grep freepbx`
cpu=`cat /proc/cpuinfo`
mem=`free -m`
disk=`df -kh .`
#clear old out info
echo 'Remove old out info file, if any...'
rm -f "${out}"
#gathering system and asterisk info
echo "linux $uname" >> $out
if ! [ -f /etc/redhat-release ];
then
echo "$deb" >> $out
else
echo "$red" >> $out
fi
echo "freepbx rpm ver $freepbx" >> $out
echo "freepbx firmware ver $pbxfirm" >> $out
echo "asterisk $astver" >> $out
echo "arch x$arc" >> $out
echo "EXT IP $ip" >> $out
echo "$cpu" >> $out
echo "$mem" >> $out
echo "$disk" >> $out
echo "AMI check: $ami" >> $out

echo "CEL status check: $cel" >> $out

echo "CEL check $celcheck" >> $out

echo "CDR check $cdrcheck" >> $out

echo "$phpver" >> $out
echo "PHP JSON check $phpjson" >> $out
echo "PHP CURL check $phpcurl" >> $out
end