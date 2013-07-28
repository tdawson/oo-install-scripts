#!/bin/bash
# Setup the node hostname

# setup variables
source ./oo-install.conf

# setup hostname
if [ "$DISTRO" == "rhel6" ] ; then
    # FIX THIS: We need a better sed argument
    sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=${NODEHOSTNAME}/" /etc/sysconfig/network
else
    echo "${NODEHOSTNAME}" > /etc/hostname
fi

