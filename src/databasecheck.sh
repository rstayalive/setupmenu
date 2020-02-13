#!/bin/bash
mysqlcheck --all-databases | grep Corrupt > /tmp/corrupt
if [ -s "/tmp/corrupt" ];
then
echo "bad. Executing fix"
mysqlcheck --repair --all-databases
#checking one more time
rm -rvf /tmp/corrupt
mysqlcheck --all-databases | grep Corrupt > /tmp/corrupt
if [ -s "/tmp/corrupt" ];
then
echo "bad. not fixed, sending email to sadmin"
mysqlcheck --all-databases > /tmp/sqlfulllog
mail -s "Mysql error, please fix me at $(hostname)" -a /tmp/sqlfulllog -r asterisk rstayalive@gmail.com < /dev/null
else
echo "All ok"
fi
else
echo "All ok"
fi
