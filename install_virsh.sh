#!/bin/bash

#Script to check prerequisites and to install kvm and subsequent tools

check_system_virt_capabilities(){
	lscpu | grep Virtualization
}

check_system_cpu_flag_count(){
	egrep -c '(vmx|svm)' /proc/cpuinfo
}

value_printer(){
	local val="$1"
	echo "Received value: '$val'"
}

value_checker(){
	local val="$1"

	#check if $val contains VT-x or AMD-V
	if [[ $val == *"VT-x"* ]]; then
		echo "Intel ok"
	elif [[ "$val" == *"AMD-V"* ]]; then
		echo "AMD OK"
	else echo "unknown or disabled hardware virtualization"
	fi
}

#Print raw values
value_printer "$(check_system_virt_capabilities)"
value_printer "$(check_system_cpu_flag_count)"

#Check and dispaly verdict
value_checker "$(check_system_virt_capabilities)"
