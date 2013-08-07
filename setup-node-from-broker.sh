#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf
GITDIR="/root/oo-install-scripts"
if [ "$1" == "--slow" ] ; then
  SLOW="yes"
fi

if [ "$SLOW" == "yes" ] ; then
    echo "Setup authentication between broker and node"
    echo "  Note: You will have to type in the node password twice."
    echo "  Hit Enter to continue"
    read testinput    
fi
sh ./broker-node-auth-setup.sh

if ! [ "$OPENSHIFT_SOURCE" == "distro" ] ; then
	if [ "$SLOW" == "yes" ] ; then
	    echo "Setup Yum Repos"
	    echo "  Hit Enter to continue"
	    read testinput    
	fi
	ssh root@${NODEHOSTNAME} "cd ${GITDIR} ; sh common-repo.sh"
fi

if [ "$SLOW" == "yes" ] ; then
    echo "Yum Update"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODEHOSTNAME} "yum clean all ; yum -y update"


if [ "$SLOW" == "yes" ] ; then
    echo "Install git and install scripts"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODEHOSTNAME} "yum -y install git"
ssh root@${NODEHOSTNAME} "cd /root/ ; git clone git://github.com/tdawson/oo-install-scripts.git"
scp ./oo-install.conf root@${NODEHOSTNAME}:${GITDIR}/

if [ "$SLOW" == "yes" ] ; then
    ssh root@${NODEHOSTNAME} "cd ${GITDIR} ; sh setup-node.sh --slow"
else
    ssh root@${NODEHOSTNAME} "cd ${GITDIR} ; sh setup-node.sh"
fi

if [ "$SLOW" == "yes" ] ; then
    echo "Reboot the node"
    echo "  Hit Enter to continue"
    read testinput    
fi
ssh root@${NODEHOSTNAME} "reboot"

