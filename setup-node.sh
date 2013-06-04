#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf
if [ "$1" == "--slow" ] ; then
  SLOW="yes"
fi

if [ "$SLOW" == "yes" ] ; then
    echo "Yum Update"
    echo "  Hit Enter to continue"
    read testinput    
fi
yum -y update

if [ "$SLOW" == "yes" ] ; then
    echo "Setup date and time"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh date-time.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup host dhcp setting"
    echo "Set hostname"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-dhcp-hostname.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup mcollective"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-mcollective.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Install and setup the node application"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-node-app.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup pam"
    echo "Setup cgroups"
    echo "Setup quota"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-pam-cgroups-quota.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup selinux"
    echo "Setup system settings"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-selinux-system.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup ssh"
    echo "Setup port-proxy"
    echo "Setup node application"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-ssh-proxy-app.sh

