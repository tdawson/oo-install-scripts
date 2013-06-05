#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# setup hostname
echo "${BROKERHOSTNAME}" > /etc/hostname

