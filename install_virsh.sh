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
	if [[ "$val" =~ VT-x|vt-x ]]; then
		echo "Intel ok"
		return 0
	elif [[ "$val" =~ AMD-V|amd-v ]]; then
		echo "AMD OK"
		return 0
	else
		echo "[FAIL] unknown or disabled virtualization"
		return 1
	fi
}

kvm_installer(){
	echo "Installing KVM packages"
	sudo dnf install -y qemu-kvm libvirt virt-install libvirt-client
}

kvm_install_checker(){
	sudo dnf list installed qemu-kvm libvirt virt-install libvirt-client
}

kvm_enable(){
	sudo systemctl enable --now libvirtd
}

kvm_status_checker(){
	systemctl is-active libvirtd && systemctl is-enabled libvirtd
}



Print raw values
value_printer "$(check_system_virt_capabilities)"
value_printer "$(check_system_cpu_flag_count)"

Check capabilities and isntall if check passes
if value_checker "$(check_system_virt_capabilities)"; then
	echo "Prerequisites met. Proceeding with installation."
	kvm_installer
else
	echo "Prereqs failed. Aborting installation."
	exit 1
fi

kvm_install_checker
kvm_enable
kvm_status_checker
