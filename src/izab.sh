#!/bin/bash
# Centos 7 and Debian 12 supported
# zabbix-agent installation script

echo "Preparing to install Zabbix Agent 2"

# OS detection
if grep -q -E "CentOS Linux 7|Red Hat Enterprise Linux 7|CentOS Linux release 7" /etc/redhat-release 2>/dev/null || [ -f /etc/centos-release ]; then
    OS="centos7"
    echo "detected CentOS 7"
elif [ -f /etc/debian_version ] && grep -q "12" /etc/debian_version 2>/dev/null; then
    OS="debian12"
    echo "detected Debian 12"
else
    echo "❌ Error. Supported onely CentOS 7 и Debian 12 (FreePBX 16/17)"
    exit 1
fi

# some questions
read -p "Enter IP Zabbix-server [z.telephonization.ru]: " SERVER_IP
SERVER_IP=${SERVER_IP:-z.telephonization.ru}

read -p "Enter zabbix-agent listen port [10050]: " AGENT_PORT
AGENT_PORT=${AGENT_PORT:-10050}

HOSTNAME=$(hostname)

# installing zabbix repo
echo "Installing zabbix repozitory"

if [ "$OS" = "centos7" ]; then
    rpm -Uvh --force https://repo.zabbix.com/zabbix/7.2/release/rhel/7/noarch/zabbix-release-latest-7.2.el7.noarch.rpm
    yum clean all
elif [ "$OS" = "debian12" ]; then
    wget -q https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb -O /tmp/zabbix-release.deb
    dpkg -i /tmp/zabbix-release.deb
    apt update -qq
fi

# installing zabbix-agent2
echo "setup zabbix-agent2 start"
if [ "$OS" = "centos7" ]; then
    yum install -y zabbix-agent2
elif [ "$OS" = "debian12" ]; then
    apt install -y zabbix-agent2
fi

# configuring conf
CONF="/etc/zabbix/zabbix_agent2.conf"
cp "$CONF" "$CONF.bak.$(date +%F_%H-%M)"

echo "Configuring zabbix $CONF (replace → sed fallback)..."

# replacing
replace_string() {
    local old="$1"
    local new="$2"
    local file="$3"
    if command -v replace >/dev/null 2>&1; then
        replace "$old" "$new" -- "$file"
    else
        sed -i "s|^$old|$new|" "$file"
    fi
}

replace_string "Server=127.0.0.1" "Server=$SERVER_IP" "$CONF"
replace_string "ServerActive=127.0.0.1" "ServerActive=$SERVER_IP" "$CONF"
replace_string "Hostname=Zabbix server" "Hostname=$HOSTNAME" "$CONF"
replace_string "# ListenPort=10050" "ListenPort=$AGENT_PORT" "$CONF"

# configuring autostart
echo "Enabling autostart zabbix-agent"
if [ "$OS" = "centos7" ]; then
    systemctl daemon-reload
    systemctl enable --now zabbix-agent2
else
    systemctl enable --now zabbix-agent2
fi
#restarting 
systemctl restart zabbix-agent2
echo "Setup Done"

# Some checks
echo "Changes in config please check for errors"
systemctl status zabbix-agent2 --no-pager | head -n 12
echo "Hostname: $(grep '^Hostname=' $CONF)"
echo "Server: $(grep '^Server=' $CONF)"
echo "ListenPort: $(grep '^ListenPort=' $CONF)"

echo -e "\n✅ All done, zabbix-agent succesfuly installed and configured"
echo "   check new zabbix host: $HOSTNAME"