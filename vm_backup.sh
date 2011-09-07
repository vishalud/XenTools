#!/bin/bash

#
# Citrix XenServer 5.5 VM Backup Script
# This script provides online backup for Citrix Xenserver 5.5 virtual machines
#
# @version	3.01
# @created	24/11/2009
# @lastupdated	01/12/2009
#
# @author	Andy Burton
# @url		http://www.andy-burton.co.uk/blog/
# @email	andy@andy-burton.co.uk
#



# Get current directory

dir=`dirname $0`

# Load functions and config

. $dir"/vm_backup.lib"
. $dir"/vm_backup.cfg"


# Switch backup_vms to set the VM uuids we are backing up in vm_backup_list

case $backup_vms in
	
	"all")
		if [ $vm_log_enabled ]; then
			log_message "Backup All VMs"
		fi
		set_all_vms
		;;	
		
	"running")
		if [ $vm_log_enabled ]; then
			log_message "Backup running VMs"
		fi
		set_running_vms
		;;
		
	"list")
		if [ $vm_log_enabled ]; then
			log_message "Backup list VMs"
		fi
		;;
		
	*)
		if [ $vm_log_enabled ]; then
			log_message "Backup no VMs"
		fi
		reset_backup_list
		;;
	
esac


# Backup VMs

backup_vm_list


# End

if [ $vm_log_enabled ]; then
	log_disable
fi
