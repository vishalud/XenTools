#!/bin/bash 
xe vm-list power-state=running | grep running > /tmp/vmlist 
#xe vm-list  | awk '!/[DN]/  {print $1 }' > /tmp/vmlist
COUNT=`wc -l < /tmp/vmlist` 
if [ "$COUNT" -lt "1" ] 
  then 
    echo "VM Not Running:"$COUNT 
  else 
    echo "Total VM Running:"$COUNT 
  fi

xe vm-list power-state=halted | grep Shutdown > /tmp/vm_shutdown
MAN_COUNT=`cat /tmp/vm_shutdown`
#if [ [ -s $MAN_COUNT ] ]
if [ "$COUNT" -lt "1" ] 
	then 
	   echo "NO VM's Manually Shutdown:"
	else 
	   echo "VM's Manually Shutdown: $MAN_COUNT"
fi 
