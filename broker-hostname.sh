#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# setup hostname
if [ "$DISTRO" == "rhel6" ] ; then
    # FIX THIS: We need a better sed argument
    sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=${BROKERHOSTNAME}/" /etc/sysconfig/network
else
    echo "${BROKERHOSTNAME}" > /etc/hostname
fi

