#!/bin/bash
while true; do mysqldump ots | bzip2 -c > database_backup/backup$(date +%d-%m-%Y).sql.bz2 && ./canary ; done