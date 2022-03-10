#!/bin/bash
echo "Installing sngrep tool"
cd /usr/src
git clone https://github.com/irontec/sngrep
cd sngrep
./bootstrap.sh
sleep 3
./configure --with-openssl --enable-unicode
sleep 3
make
sleep 3
make install
echo "alias sngrep='NCURSES_NO_UTF8_ACS=1 sngrep'" >> ~/.bashrc
echo export NCURSES_NO_UTF8_ACS=1 >> /etc/environment
echo "Job done."