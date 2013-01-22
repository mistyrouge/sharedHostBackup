#!/bin/bash 

HOST="your.ftp.host.dom"
USER="username"
PASS="password"
LCD="/path/of/your/local/dir"
RCD="/path/of/your/remote/dir"
NOW=$(date +"%Y-%m-%d")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

##
# First put the the php script on the server
##
ftp -inv $HOST << EOF
user $USER $PASS
lcd $DIR
cd $RCD
put dumpdb.php
bye
EOF

##
# Dump the database to db-backup.sql
##
curl http://$HOST/dumpdb.php

##
# Create needed directories
##
mkdir $LCD

##
# Download all the files from the ftp
##
lftp -c "set ftp:list-options -a;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
mirror --delete --verbose --exclude-glob .git*"

##
# remove the database dump and php script form the server
##
ftp -inv $HOST << EOF
user $USER $PASS
cd $RCD
delete dumpdb.php
delete db-backup.sql
bye
EOF

##
# commit changes to git
##
cd $LCD
git add .
git commit -a -m $NOW

echo "--- The END ---"