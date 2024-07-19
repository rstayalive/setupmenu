#!/bin/bash
#asterisk info gather script
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
    os_version=$(cat /etc/redhat-release)
else
    os_version=$(cat /etc/debian_version)
fi
pbxfirm=$(cat /etc/schmooze/pbx-version 2>/dev/null)
ip=$(fwconsole extip 2>/dev/null)
freepbx=$(rpm -qa | grep freepbx)
cpu=$(cat /proc/cpuinfo)
mem=$(free -h)
disk=$(df -kh)
#clear old out info
rm -f "${out}"
#gathering system and asterisk info
{
    echo "──────────────────────────────────────────────────────"
    echo "Linux Kernel Version: $uname"
    echo "──────────────────────────────────────────────────────"
    echo "OS Version: $os_version"
    echo "──────────────────────────────────────────────────────"
    echo "Architecture: x$arc"
    echo "──────────────────────────────────────────────────────"
    echo "External IP: $ip"
    echo "──────────────────────────────────────────────────────"
    echo "CPU Info:"
    echo "$cpu"
    echo "──────────────────────────────────────────────────────"
    echo "Memory Info:"
    echo "$mem"
    echo "──────────────────────────────────────────────────────"
    echo "Disk Usage:"
    echo "$disk"
    echo "──────────────────────────────────────────────────────"
    echo "FreePBX RPM Version: $freepbx"
    echo "──────────────────────────────────────────────────────"
    echo "FreePBX Firmware Version: $pbxfirm"
    echo "──────────────────────────────────────────────────────"
    echo "Asterisk Version: $astver"
    echo "──────────────────────────────────────────────────────"
    echo "AMI Settings:"
    echo "$ami"
    echo "──────────────────────────────────────────────────────"
    echo "CEL Status:"
    echo "$cel"
    echo "──────────────────────────────────────────────────────"
    echo "CEL Check:"
    echo "$celcheck"
    echo "──────────────────────────────────────────────────────"
    echo "CDR Check:"
    echo "$cdrcheck"
    echo "──────────────────────────────────────────────────────"
    echo "PHP Version: $phpver"
    echo "──────────────────────────────────────────────────────"
    echo "PHP JSON Check:"
    echo "$phpjson"
    echo "──────────────────────────────────────────────────────"
    echo "PHP CURL Version:"
    echo "$phpcurl"
    echo "──────────────────────────────────────────────────────"
} > "$out"
echo -e "Файл отчета лежит по пути: $out"