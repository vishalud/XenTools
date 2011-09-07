#!/bin/bash 
xe vm-list power-state=running | grep running > /tmp/vmlist 
COUNT=`wc -l < /tmp/vmlist` 
if [ "$COUNT" -lt "1" ] 
  then 
    echo "ScriptRes:VM DOWN:"$HALTCOUNT 
  else
xe vm-list power-state=halted | grep halted > /tmp/vmhalted
HALTCOUNT=`wc -l < /tmp/vmhalted`
if [ "$HALTCOUNT" -lt "1" ]
then 
    echo "Total VM's Running:"$COUNT 
  fi
fi
echo "Total VM's Halted:"$HALTCOUNT
