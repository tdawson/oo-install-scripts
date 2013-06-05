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
sh common-date-time.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup host dhcp setting"
    echo "Set hostname"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-dhcp.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup host dhcp setting"
    echo "Set hostname"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-hostname.sh

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
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-pam.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup cgroups"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-cgroups.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup quota"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-quota.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup selinux"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-selinux.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup system settings"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-system.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup ssh"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-ssh.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup port-proxy"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-proxy.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Configure node application"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh node-app-config.sh

