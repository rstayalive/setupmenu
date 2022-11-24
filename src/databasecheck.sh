#!/bin/bash
echo "Checking corrupted SQL database tables "
mysqlcheck --all-databases | grep Corrupt > /tmp/corrupt
if [ -s "/tmp/corrupt" ];
then
echo "bad. Executing fix"
mysqlcheck --repair --all-databases > /dev/null 2>&1
echo "Fixed"
#checking one more time
rm -rvf /tmp/corrupt
mysqlcheck --all-databases | grep Corrupt > /tmp/corrupt
if [ -s "/tmp/corrupt" ];
then
echo "Databased bad. not fixed!!!!!"
echo "Mysql error, please fix sql database manualy"
else
echo "All ok"
fi
else
echo "All ok"
fi
echo -e "$GRE press any key to continue $DEF"
read -s -n 1