#!/bin/bash
kernel_parameter_list=$(cat /proc/cmdline)
target_parameter="vfio-pci"
if [[ $kernel_parameter_list =~ $target_parameter ]];
then
    echo "Vfio Parameter Passed In"
    virsh start win10-amd-PCI-1--autostart
else
    echo "Vfio not set"
fi
