#!/bin/bash
# Define the configuration file
config_file="/etc/freepbx.conf"
# Output file
report="/tmp/asterisk_report.txt"

# Function to extract the value of a given key from the PHP configuration file
extract_value() {
    local key=$1
    awk -v key="$key" '
    BEGIN { FS=" *= *" }
    $1 ~ "\\$amp_conf\\[\\s*\"" key "\\\"" { gsub(/[";]/, "", $2); print $2 }
    ' "$config_file"
}

# Extract db credentials
username=$(extract_value "AMPDBUSER")
password=$(extract_value "AMPDBPASS")
host=$(extract_value "AMPDBHOST")
databasename=$(extract_value "AMPDBNAME")

# MySQL credentials
DB_USER="$username"
DB_PASS="$password"
DB_NAME="$databasename"

# Determine architecture
arc=`arch`
if [ "$arc" == "x86_64" ];then
 arc=64
else
 arc=86
fi

# Gather additional system information
uname=$(uname -r)
if [ -f /etc/redhat-release ]; then
    os_version=$(cat /etc/redhat-release)
else
    os_version=$(cat /etc/debian_version)
fi

# Gather information
hname=$(hostname)
astver=$(asterisk -V | grep -woE [0-9]+\.)
ami=$(asterisk -rx 'manager show settings')
cel=$(asterisk -rx 'cel show status')
celcheck=$(mysql -u $DB_USER -p$DB_PASS asteriskcdrdb --execute="SELECT id, eventtype, eventtime, cid_num, exten, uniqueid, linkedid, channame FROM cel ORDER BY id DESC LIMIT 10;" 2>/dev/null)
cdrcheck=$(mysql -u $DB_USER -p$DB_PASS asteriskcdrdb --execute="SELECT recordingfile FROM cdr ORDER BY calldate DESC LIMIT 10;" 2>/dev/null)
phpver=$(php -v)
phpjson=$(php -r 'var_dump(function_exists("json_decode"));')
phpcurl=$(php -r 'echo curl_version()["version"];')
pbxfirm=$(cat /etc/schmooze/pbx-version 2>/dev/null)
ip=$(fwconsole extip 2>/dev/null)
freepbx=$(rpm -qa | grep freepbx)
cpu=$(cat /proc/cpuinfo)
mem=$(free -h)
disk=$(df -kh)
# Function to gather extensions
sipext=$(rasterisk -rx "sip show peers" | awk '/^[0-9]+\/[0-9]+/ {split($1, a, "/"); print a[1]}' | awk 'length($0) < 5')
pjsipext=$(rasterisk -rx "pjsip list endpoints" | awk '/Endpoint:/{print $2}' | sed 's#/.*##' | grep -E '^[0-9]{1,4}$')
# Function to gather trunks
siptrunk=$(asterisk -rx "sip show registry")
pjsiptrunk=$(asterisk -rx "pjsip list registrations")
# Function to gather ring groups
ringgroups=$(mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "SELECT grpnum, strategy, grppre, grplist, postdest FROM ringgroups")
# Function to gather queues
queues=$(mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "SELECT extension, descr, dest FROM queues_config")
# Function to gather IVR
ivrmenu=$(mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "SELECT id, name, directdial, timeout_time, timeout_destination, invalid_destination FROM ivr_details")

# Clear the output file
> $report

# Making report
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
    echo "SIP extensions"
    echo "$sipext"
    echo "──────────────────────────────────────────────────────"
    echo "PJSIP extensions"
    echo "$pjsipext"
    echo "──────────────────────────────────────────────────────"
    echo "Ring Groups"
    echo "$ringgroups"
    echo "──────────────────────────────────────────────────────"
    echo "Queues"
    echo "$queues"
    echo "──────────────────────────────────────────────────────"
    echo "IVR"
    echo "$ivrmenu"
    echo "──────────────────────────────────────────────────────"
    echo "SIP Trunks"
    echo "$siptrunk"
    echo "──────────────────────────────────────────────────────"
    echo "PJSIP Trunks"
    echo "$pjsiptrunk"
    echo "──────────────────────────────────────────────────────"
} > "$report"
echo -e "Файл отчета лежит по пути: $report"