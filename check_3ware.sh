#!/bin/bash
#
# check_3ware.sh
#
# Simple script to check the status of arrays on 3ware/AMCC controllers
# using Nagios.
# 
# Sander Klein <sander [AT] pictura [dash] dp [DOT] nl>
# http://www.pictura-dp.nl/
# Contributions by:
# Dan Langille
# http://www.freebsddiary.org/
#
# Version 20100920
#
# BUGS: Sure...
#

TWCLI=`which tw_cli`
EXITCODE=0
BBUEXITCODE=0
GREP=`which grep`
AWK=`which awk`

#
# Preflight check...
#

if [ "$UID" -ne 0 ]; then
	echo "You must be root to use this program..."
	exit 3
fi

if [ -z $TWCLI ] || [ ! -x $TWCLI ]; then
	echo "tw_cli not installed or not executable..."
	exit 3
fi

if [ ! -x ${GREP} ] || [ ! -x ${AWK} ]; then
	echo "grep or awk not installed on this system..."
	exit 3
fi

#
# Let the games begin!
#

# Find out which controllers are available...
CONTROLLERS=`$TWCLI info|${GREP} -E "^c"|${AWK} '{print $1}'`

for i in $CONTROLLERS; do
	UNITSTATUS=`$TWCLI info $i unitstatus|${GREP} -E "^u"|${AWK} '{print $3}'`

	# Create an array containing the units
	UNIT=(`$TWCLI info $i unitstatus|${GREP} -E "^u"|${AWK} '{print $1}'`)

	#Counter for the array
	COUNT=0
	for j in $UNITSTATUS; do
		case "$j" in
			OK)
				CHECKUNIT=`$TWCLI info $i unitstatus | ${GREP} -E "${UNIT[$COUNT]}" | ${AWK} '{print $1,$3}'`
				STATUS="/$i/$CHECKUNIT"
				OKSTATUS="$OKSTATUS $STATUS -"
				PREEXITCODE=0
				;;
			REBUILDING)
				CHECKUNIT=`$TWCLI info $i unitstatus | ${GREP} -E "${UNIT[$COUNT]}" | ${AWK} '{print $1,$3,$4}'`
				STATUS="/$i/$CHECKUNIT%"
				MSG="$MSG $STATUS -"
				PREEXITCODE=1
				;;
			VERIFYING)
				CHECKUNIT=`$TWCLI info $i unitstatus | ${GREP} -E "${UNIT[$COUNT]}" | ${AWK} '{print $1,$3,$5}'`
				STATUS="/$i/$CHECKUNIT"
				MSG="$MSG $STATUS -"
				PREEXITCODE=1
				;;
			DEGRADED)
				CHECKUNIT=`$TWCLI info $i unitstatus | ${GREP} -E "${UNIT[$COUNT]}" | ${AWK} '{print $1,$3}'`
				STATUS="/$i/$CHECKUNIT"
				# Check which disk has failed
				DRIVE=`$TWCLI info $i drivestatus | ${GREP} -E "${UNIT[$COUNT]}" | ${GREP} -v -i "OK" | ${AWK} '{print $1,$2}'`
				MSG="$MSG $STATUS Reason: $DRIVE -"
				PREEXITCODE=2
				;;
			*)
				CHECKUNIT=`$TWCLI info $i unitstatus | ${GREP} -E "${UNIT[$COUNT]}"`
				STATUS="/$i/$CHECKUNIT"
				MSG="$MSG $STATUS -"
				PREEXITCODE=3
				;;
		esac

		# Make sure we always exit with the most important warning
		# OK is least and UNKNOWN is the most important in this case
		if [ $PREEXITCODE -gt $EXITCODE ]; then
			EXITCODE=$PREEXITCODE
		fi

		let COUNT=$COUNT+1
	done

	# Check BBU's
	BBU=(`$TWCLI info $i |${GREP} -E "^bbu"|${AWK} '{print $1,$2,$3,$4,$5}'`)
	if [ "${BBU[0]}" = "bbu" ]; then
		# bbu   On           No        Charging  OK       OK       255    02-Sep-2010
		if [ "${BBU[2]}" = "No" ] && ( [ "${BBU[3]}" = "Testing" ] || [ "${BBU[3]}" = "Charging" ] ); then
			BBUEXITCODE=1
			BBUWARNING="BBU on $i is ${BBU[3]}"
		else
			if [ "${BBU[1]}" != "On" ] || [ "${BBU[2]}" != "Yes" ] || [ "${BBU[3]}" != "OK" && "${BBU[3]}" != "Testing" ] || [ "${BBU[4]}" != "OK" ]; then
				BBUEXITCODE=2
				BBUERROR="BBU on $i failed"
			fi
		fi
	fi
done

if [ $EXITCODE -lt $BBUEXITCODE ]; then
	EXITCODE=$BBUEXITCODE
fi

case "$EXITCODE" in
	0)
		echo "UNITS OK: $OKSTATUS"
		exit 0
		;;
	1)
		echo "WARNING: $BBUWARNING$MSG$OKSTATUS"
		exit 1
		;;
	2)
		echo "CRITICAL: $BBUERROR$MSG$OKSTATUS"
		exit 2
		;;
	*)
		echo "UNKNOWN: $MSG$OKSTATUS"
		exit 3
		;;
esac

# That's it, That's all, That's all there is...
