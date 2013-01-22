#!/bin/bash 

HOST="your.ftp.host.dom"
USER="username"
PASS="password"
LCD="/path/of/your/local/dir"
RCD="/path/of/your/remote/dir"

curl http://@HOST/dumpdb.php

lftp -c "set ftp:list-options -a;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
mirror --reverse \
       --delete \
       --verbose"