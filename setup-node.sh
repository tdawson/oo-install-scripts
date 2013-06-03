#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source oo-install.conf

# Update to latest packages
yum -y update

# Make sure date and time are correct
sh date-time.sh

sh node-dhcp-hostname.sh
sh node-mcollective.sh
sh node-node-app.sh
sh node-pam-cgroups-quota.sh
sh node-selinux-system.sh
sh node-ssh-proxy-app.sh

