#!/bin/bash
#freePBX mysql db optimization script
echo "Job start. Please wait. Operation may be running about 30 min"
echo "SQL database backup start"
mysqldump --extended-insert --all-databases --add-drop-database --disable-keys --flush-privileges --quick --routines --triggers | gzip > /root/freepbx.sql.gz
fwconsole reload
echo "Database backup done. Backup stored here -> /root/freepbx.sql.gz"
echo "CDR cleaner started"
mysql asteriskcdrdb --execute="DELETE FROM cdr WHERE calldate < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CDR clear done"
echo "CEL cleaner started"
mysql asteriskcdrdb --execute="DELETE FROM cel WHERE eventtime < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CEL clear done"
echo "Do some magic to speedup SQL"
mysql asteriskcdrdb --execute="DELETE cdr, cel FROM cdr RIGHT JOIN cel ON cdr.uniqueid = cel.uniqueid WHERE calldate < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CEL & CDR links clear done"
fwconsole reload
echo "SQL database optimization stated"
mysqlcheck --auto-repair --optimize --all-databases &> /dev/null
echo "Database optimization done"
echo "All jobs done. SQL database cleaned and optimized."
echo -e "$GRE press any key to continue $DEF"
read -s -n 1