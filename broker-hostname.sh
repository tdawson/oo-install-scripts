#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# setup hostname
if [ "$DISTRO" == "rhel6" ] ; then
    sed -i "s/HOSTNAME=.*/HOSTNAME=${BROKERHOSTNAME}/" /etc/sysconfig/network
else
    echo "${BROKERHOSTNAME}" > /etc/hostname
fi

hostname ${BROKERHOSTNAME}
