#!/bin/sh

localdisk=`xe sr-list name-label="Local storage" | grep uuid | awk '{print $5}'`
utilizeddisk=`xe sr-param-get uuid=$localdisk param-name=physical-utilisation`
totaldisk=`xe sr-param-get uuid=$localdisk param-name=physical-size`
totaldiskgb=`echo "$totaldisk/(1024*1024*1024)" | bc`
utilizeddiskgb=`echo "$utilizeddisk/(1024*1024*1024)" | bc`
freespace=`echo $totaldiskgb - $utilizeddiskgb | bc`
percentused=`echo "($utilizeddiskgb*100/$totaldiskgb)" | bc`
	if [ $percentused -lt 90 ];then
		echo Total Disk = $totaldiskgb GB, Disk Utilized = $utilizeddiskgb GB, Used Disk = $freespace GB, Percent Used = $percentused%
		exit 0
	else
		echo Total Disk = $totaldiskgb GB, Disk Utilized = $utilizeddiskgb GB, Used Disk = $freespace GB, Percent Used = $percentused%
		exit 2
	fi
