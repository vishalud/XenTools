#!/bin/bash
CONTROL_DOMAIN=`xe vm-list | grep -i -B1 control | grep uuid  | sed -e 's/[^:]*: //'`
date=`date +%F`
        ALL_SNAPSHOTS=`xe snapshot-list | grep uuid | sed -e 's/[^:]*: //' | grep -iv $CONTROL_DOMAIN`
        AVAILABLE_SNAPSHOTS=`xe snapshot-list | grep name | sed -e 's/[^:]*: //' | grep -iv control`
        echo "Begining to delte the snapshot of the following VM's...."
        echo "$AVAILABLE_SNAPSHOTS"


        for uuid in $ALL_SNAPSHOTS
                do
                        NAME2UUID=`xe snapshot-list | grep -A1 $uuid | grep uuid | sed -e 's/[^:]*: //'`
                        echo "Attempting to Delete snapshot of $UUID2NAME."
                        SNAPUUID=`xe snapshot-list | grep name-label=$UUID2NAME`
			echo "Removing snapshot of $NAME2UUID"
			xe snapshot-destroy uuid=$NAME2UUID force=true 
			
        done
