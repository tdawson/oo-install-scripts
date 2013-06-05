#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf
GITDIR="/root/oo-install-scripts"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup authentication between broker and node"
    echo "  Note: You will have to type in the node"
    echo "        password twice."
    echo "  Hit Enter to continue"
    read testinput    
fi
broker-node-auth-setup.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Yum Update"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "yum -y update"


if [ "$SLOW" == "yes" ] ; then
    echo "Install git and install scripts"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "yum -y install git"
ssh root@${NODENAME} "cd /root/ ; git clone git://github.com/tdawson/oo-install-scripts.git"
scp ./oo-install.conf root@${NODENAME}:${GITDIR}/

if [ "$SLOW" == "yes" ] ; then
    echo "Setup date and time"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh date-time.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup host dhcp setting"
    echo "Set hostname"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-dhcp-hostname.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup mcollective"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-mcollective.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Install and setup the node application"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-node-app.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup pam"
    echo "Setup cgroups"
    echo "Setup quota"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-pam-cgroups-quota.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup selinux"
    echo "Setup system settings"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-selinux-system.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Setup ssh"
    echo "Setup port-proxy"
    echo "Setup node application"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-ssh-proxy-app.sh"

if [ "$SLOW" == "yes" ] ; then
    echo "Reboot the node"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODENAME} "reboot"

