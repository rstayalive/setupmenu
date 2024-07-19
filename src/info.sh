#!/bin/bash
#asterisk info gather script
end()
{
echo -e "файл с иформацией лежит $out, нажмите любую кнопку для продолжения"
read -s -n 1
}
# Determine architecture
arc=`arch`
if [ "$arc" == "x86_64" ];then
 arc=64
else
 arc=86
fi
# Gather system information
astver=$(asterisk -V | grep -woE [0-9]+\.)
ami=$(asterisk -rx 'manager show settings')
cel=$(asterisk -rx 'cel show status')
celcheck=$(mysql asteriskcdrdb --execute="SELECT id, eventtype, eventtime, cid_num, exten, uniqueid, linkedid, channame from cel order by id desc limit 10" ;)
cdrcheck=$(mysql asteriskcdrdb --execute="SELECT recordingfile from cdr order by calldate desc limit 10" ;)
phpver=$(php -v)
phpjson=$(php -r 'var_dump(function_exists("json_decode"));')
phpcurl=$(php -r 'echo curl_version()["version"];')
# Output file
out="/tmp/outputinfo.txt"
# Gather additional system information
uname=$(uname -r)
if [ -f /etc/redhat-release ]; then
    red=$(cat /etc/redhat-release)
    os_version="$red"
else
    deb=$(cat /etc/debian_version)
    os_version="$deb"
fi
pbxfirm=$(cat /etc/schmooze/pbx-version 2>/dev/null)
ip=$(fwconsole extip 2>/dev/null)
freepbx=$(rpm -qa | grep freepbx)
cpu=$(cat /proc/cpuinfo)
mem=$(free -m)
disk=$(df -kh)
#clear old out info
rm -f "${out}"
#gathering system and asterisk info
{
    echo "Linux Kernel Version: $uname"
    echo "OS Version: $os_version"
    echo "Architecture: x$arc"
    echo "External IP: $ip"
    echo "CPU Info: $cpu"
    echo "Memory Info: $mem"
    echo "Disk Usage: $disk"
    echo "FreePBX RPM Version: $freepbx"
    echo "FreePBX Firmware Version: $pbxfirm"
    echo "Asterisk Version: $astver"
    echo "AMI Settings: $ami"
    echo "CEL Status: $cel"
    echo "CEL Check: $celcheck"
    echo "CDR Check: $cdrcheck"
    echo "PHP Version: $phpver"
    echo "PHP JSON Check: $phpjson"
    echo "PHP CURL Version: $phpcurl"
} > "$out"
end