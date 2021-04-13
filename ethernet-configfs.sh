#!/bin/bash

##
## load libcomposite and configure an ethernet gadget
## run at boot from systemd, cron, or rc.local
## must be run as root or with sudo
##

#
# configuration parameters.
# sensible defaults but change as desired
GADGETDIR='mygadget' # full path should not be supplied
SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2` # Pi's serial number
HOSTPREFIX="02"     # hex, two digits only
DEVICEPREFIX="06"   # hex, two digits only
MANUFACTURER="nobody"
PRODUCT='nothing'
INCLUDEUART=0 # set to 1 if a serial gadget is needed for troubleshooting
#

# calculate MAC addresses
padded='00000000000000'$SERIAL
for i in -10 -8 -6 -4 -2; do
    basemac=$basemac':'${padded: $i:2}
done
hostmac=$HOSTPREFIX$basemac
devmac=$DEVICEPREFIX$basemac

# am I root?
if [ $# != 0 ]; then
	echo "Must be root" >&2
	exit 1
fi

modprobe libcomposite
if [ $? -ne 0 ]; then
    echo "unable to load libcomposite, exiting"
    exit 1
fi

mkdir -p /sys/kernel/config/usb_gadget/$GADGETDIR
cd /sys/kernel/config/usb_gadget/$GADGETDIR
echo 0x1d6b > idVendor 
echo 0x0104 > idProduct
echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB
mkdir -p strings/0x409
echo $SERIAL > strings/0x409/serialnumber
echo $MANUFACTURER > strings/0x409/manufacturer
echo $PRODUCT > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
mkdir -p functions/ecm.usb0
echo $hostmac > functions/ecm.usb0/host_addr
echo $devmac > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
if [ $INCLUDEUART -eq 1 ]; then
    mkdir -p functions/acm.usb0
    ln -s functions/acm.usb0 configs/c.1/  
fi
ls /sys/class/udc > UDC
