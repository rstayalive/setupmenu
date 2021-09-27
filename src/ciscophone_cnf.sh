#!/bin/bash

echo -e "mac please"
read MAC;
echo -e "Extension please"
read exten;
echo -e "Extension passwd please"
read passwd;

path=/tftpboot

cp $path/example.cnf.xml $path/SEP$MAC.cnf.xml
replace "#extension" "$exten" -- $path/SEP$MAC.cnf.xml
replace "#password" "$passwd" -- $path/SEP$MAC.cnf.xml

touch $path/ITLSEP$MAC.tvl
touch $path/CTLSEP$MAC.tvl

chown -R asterisk:asterisk $path/
