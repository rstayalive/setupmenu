#!/bin/bash
#freePBX mysql db optimization script
echo "Job start. Please wait. Operation may take around 30 minutes."
# Step 1: SQL Database Backup
echo "SQL database backup start"
backup_file="/root/freepbx_$(date +'%Y%m%d_%H%M%S').sql.gz"
mysqldump --extended-insert --all-databases --add-drop-database --disable-keys --flush-privileges --quick --routines --triggers | gzip > "$backup_file"
if [ $? -eq 0 ]; then
    echo "Database backup done. Backup stored here -> $backup_file"
else
    echo "Database backup failed. Exiting."
    exit 1
fi
# Step 2: Reload FreePBX Configuration
fwconsole reload
# Step 3: CDR Cleaner
echo "CDR cleaner started"
mysql asteriskcdrdb --execute="DELETE FROM cdr WHERE calldate < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CDR clear done"
# Step 4: CEL Cleaner
echo "CEL cleaner started"
mysql asteriskcdrdb --execute="DELETE FROM cel WHERE eventtime < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CEL clear done"
# Step 5: Clear CEL & CDR Links
echo "Do some magic to speedup SQL"
mysql asteriskcdrdb --execute="DELETE cdr, cel FROM cdr RIGHT JOIN cel ON cdr.uniqueid = cel.uniqueid WHERE calldate < DATE_SUB(now(), INTERVAL 12 MONTH)" ;
echo "CEL & CDR links clear done"
# Step 6: SQL Database Optimization
echo "SQL database optimization stated"
mysqlcheck --auto-repair --optimize --all-databases &> /dev/null
echo "Database optimization done"
echo "All jobs done. SQL database cleaned and optimized."
echo -e "press any key to continue"
read -s -n 1