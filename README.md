# PCI Passthrough Configuration

This folder contains the file contents I currently use to run Windows 10 as a guest VM on my Arch Linux operating system    
This particular configuration utilizes a PCI passed through Rx570 which allowsgaming-like performance in the guest virtual machine.    
I use grub to specify one of 3 options:
- First, boot into Linux using both GPUs on the host
- Second, boot into Linux using host GPU and prepare second GPU for passthrough to win10 VM
- Third, boot into Windows using both GPUs on Win10

#### `grub.txt`
`grub.txt` contains the start commands that my grub bootloader runs during it's boot sequence.    
The only difference between this and the regular Arch Linux boot parameters are the *kernel parameters* passed in at line `13`.    
Here we pass in the vfio-pci ids of the Rx570 GPU in order to tell the kernel to ignore the device and prepare to pass it to a virtual machine.    
Subtract `amd_iommu=on iommu=pt` (optional) and `vfio-pci.ids=1002:67df,1002:aaf0,1022:145c` and linux will boot normally with both GPUs   
Note, `module_blacklist=amdgpu` is not necessary, it is included as a catch in case there is a driver conflict between the amdgpu and vfio drivers. It works in my case because I use a nvidia gpu on my Arch Linux host and an amd on the win10 VM. Remember to delete this option any time you expect to utilize an amd GPu on your linux host system.

#### `vmStartScript.sh`
This `bash` script is responsible for starting the virtual machine whenever it detects that some `vfio-pci` ids are passed into the kernel as kernel parameters. The Linux VirtManager comes with an autostart, but this method allows me to use grub options to determine whether or not to boot the Win10 VM rather than having it autostart after every boot.    
Place this somewhere useful. I recommend placing this somewhere in the `/etc/` directory.


#### `vmStartScript.service`
This `systemd` unit is responsible for calling the `vmStartScript.sh` bash script. This unit when enabled will call the script once every boot. The bash script will decide whether or not to start up the win10 VM.    
In order to install this service:   
Open `vmStartScript.service`    
Insert the correct path to the `vmStartScript.sh` script.    
Copy `vmStartScript.service` to the `/etc/systemd/system/` directory and run `systemctl daemon-reload`    
Then run `systemctl start vmStartScript` and `systemctl enable vmStartScript`


#### `win10VM.xml`
This `xml` file contains the `libvirt` configuration settings for the VM. Simply copy and paste this into VirtManager to copy my VM configuration. Note: The PCI ids will be different, and your CPU topography will likely also be different. Those will have to be changed. In addition, I use PCI passthrough to pass through whole USB hubs. These will also have to be changed. 


#### My Source:
Arch Linux wiki article: [PCI passthrough via OVMF](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF)

#### My Hardware:
- GT 710 (Host)
- Rx570 (Guest)
- Ryzen 7 1700
