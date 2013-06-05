#!/bin/bash
# Setup the node hostname

# setup variables
source ./oo-install.conf

# setup hostname
echo "${NODEHOSTNAME}" > /etc/hostname

