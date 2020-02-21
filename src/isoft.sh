#!/bin/bash
#This script install admin tools to system
myinstall()
{
if [ -z `rpm -qa $1` ]; then
    yum -y install $1
else
    echo "$1 already installed"
fi
}
#end
end()
{
echo -e "Press any key to continue"
read -s -n 1
}
clear
echo "Installing software... Please relax"
    myinstall mc
    myinstall mtr
    myinstall iotop
    myinstall lm_sensors.x86_64
    myinstall nmap
    myinstall ncurses-devel
    myinstall make
    myinstall libpcap-devel
    myinstall pcre-devel
    myinstall openssl-devel
    myinstall git
    myinstall gcc
    myinstall autoconf
    myinstall automake
    myinstall iptraf
    myinstall ccze
    myinstall smartmontools
    myinstall nmon
	myinstall lz4
	myinstall lz4-devel
echo "Installing sngrep tool"
cd /usr/src
git clone https://github.com/irontec/sngrep
cd sngrep
./bootstrap.sh
sleep 3
./configure --with-openssl --enable-unicode
sleep 3
make
speep 3
make install
echo "alias sngrep='NCURSES_NO_UTF8_ACS=1 sngrep'" >> ~/.bashrc
echo export NCURSES_NO_UTF8_ACS=1 >> /etc/environment
echo "Job done."
service smartd start
chkconfig smartd on
end