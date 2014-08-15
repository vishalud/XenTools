#!/bin/bash

#
# Citrix XenServer 5.5 VM Backup Script



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
