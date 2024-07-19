#!/bin/bash
#FreePBX mariadb database error check and repair
# Define variables
corrupt_file="/tmp/corrupt"
echo "Checking corrupted SQL database tables..."
mysqlcheck --all-databases | grep Corrupt > "$corrupt_file"
if [ -s "$corrupt_file" ]; then
echo "Corrupted tables found. Executing repair..."
 # Repair corrupted tables
mysqlcheck --repair --all-databases > /dev/null 2>&1
 echo "Repair attempt completed."
# Recheck for corrupted tables
rm -f "$corrupt_file"
mysqlcheck --all-databases | grep Corrupt > "$corrupt_file"
if [ -s "$corrupt_file" ]; then
 echo "Database is still corrupted. Manual intervention required."
 echo "MySQL error: please fix the SQL database manually."
else
 echo "All corrupted tables have been successfully repaired."
fi
else
echo "No corrupted tables found. All OK."
fi
# Clean up temporary file
rm -f "$corrupt_file"
echo -e "Press any key to continue..."
read -s -n 1