#!/bin/bash 
CONTROL_DOMAIN=`xe vm-list | grep -i -B1 control | grep uuid  | sed -e 's/[^:]*: //'`
date=`date +%F`
	ALL_VMS=`xe vm-list | grep uuid | sed -e 's/[^:]*: //' | grep -iv $CONTROL_DOMAIN`
	AVAILABLE_VMS=`xe vm-list | grep name | sed -e 's/[^:]*: //' | grep -iv control`
	echo "Begining to snapshot the following VM's...."
	echo "$AVAILABLE_VMS"


	for uuid in $ALL_VMS
		do 
			UUID2NAME=`xe vm-list | grep -A1 $uuid | grep name | sed -e 's/[^:]*: //'`
			echo "Creating snapshot of $UUID2NAME."
			SNAPUUID=`xe vm-snapshot vm=$uuid new-name-label=$UUID2NAME-$date`
	done 



