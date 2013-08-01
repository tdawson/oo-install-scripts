#!/bin/bash
# Setup the node hostname

# setup variables
source ./oo-install.conf

# setup hostname
if [ "$DISTRO" == "rhel6" ] ; then
    sed -i "s/HOSTNAME=.*/HOSTNAME=${NODEHOSTNAME}/" /etc/sysconfig/network
else
    echo "${NODEHOSTNAME}" > /etc/hostname
fi

