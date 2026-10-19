Explanation of the cpu checker and install bash script

NOTES:
1) bash is dissimilar to python in regards to passing values directly to return, this cannot be done and has to be directed into a variable then passed to other functions. 


Explanation: 
1) check_system_virt_capabilities()
This function runs lscpu and filters the output with grep. 
Expected outputs are: 
	Virtualization:		VT-x (this means the processor is intel and virtualization is enabled in BIOS/UEFI
	Virtualization: 	AMD-V (this means the processor and hardware virtualization enabled in BIOS/UEFI is AMD.
	blank/returns nothing (CPU does not support hardware virtualization, or VT-x AMD-V is turned off in the BIOS/UEFI settings. 

2) check_system_cpu_flag_count()
This function runs extended grep on the /proc/cpuinfo virtual file exposed by the Linux kernel that displays metadata about processors and other hardware. 
'vmx|svm' are hardare acceleration feature flags assigned by CPU manufacturers.vmx: Virtual Machine eXtension (intl)
svm: Secure Virtual Machin (AMD)
-c (count flag) outputs the total count of lines that match the search pattern. /proc/cpuinfo lists feature flags once per logical CPU core/thread, the output will equal the number of logical CPU cores with hardware virtualization enabled. 

3) value_printer()
This function uses positional arguments to store returned values from the first two functions into variables to be later passed into value parsing functions. 
local val="$1" $1 represents the first argument passed into the function when you call it. local restrics the variable val so it only exists inside value checker. "$1" prevent Bash from splitting strings with spaces or newlines

4) value_checker()
This function uses positional arguments and checks the value of the check_system_virt_capabilities to determine if intel or AMD virtualization is enabled in BIOS. 
$1 is the first positional argument passed intoo the function (output of check_system_virt_capabilties). Local ensures the variable val exists inside the function. Quotes around "$1" perserve any whitespace or multi-word output. 
[[ ... ]] is Bash's extended test command. Double brackets support pattern matching using wildcards. 
*"VT-x"* matches the pattern containing VT-x, same thing with the AMD-V portion of in the elif statement. fi closes the if statement. 

5) kvm_installer()
This function uses the dnf package manager to install qemu-kvm, libvirt, virt-install and libvirt-client
qemu-kvm: core hypervisor that provides kernel level hardware virtualization
libvirt: background daemon service (libvirtd) that manages the lifecycle, networking, and storage of a virtual machine
virt-install: command line tool used to create, configure, and provision new virtual machines
libvirt-client: client-side utilities and API libraries (including virsh) that allow users to manage hypervisors remotely or locally

6) install_checker()
uses the list install parameters with dnf to verify if the packages were installed

7) kvm_enable()
starts the libvirt daemon now and enables it upon startup with systemctl

8) kvm_status_checker
Checkes the status with systemctl is the service is active and enabled and prints the results

function calls and logic (determining if the prereqs are met and to proceed with installation of the actual packages. 
