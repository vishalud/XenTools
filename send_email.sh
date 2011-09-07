#!/bin/bash

MESSAGE=`cat /var/log/vm_backup.log`
/usr/sbin/ssmtp -v syseng.internal@directi.com << EOF 
To: syseng.internal@directi.com 
Subject: Status of VM backups 

$MESSAGE 

EOF 
