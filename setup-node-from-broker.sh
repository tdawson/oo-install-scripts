#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf
GITDIR="/root/oo-install-scripts"

# Setup ssh autentication between broker and node
broker-node-auth-setup.sh

# Update to latest packages
ssh root@${NODENAME} "yum -y update"

# Setup the scripts we need to update.
ssh root@${NODENAME} "yum -y install git"
ssh root@${NODENAME} "cd /root/ ; git clone git://github.com/tdawson/oo-install-scripts.git"

# Make sure date and time are correct
ssh root@${NODENAME} "cd ${GITDIR} ; sh date-time.sh"

ssh root@${NODENAME} "cd ${GITDIR} ; sh node-dhcp-hostname.sh"
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-mcollective.sh"
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-node-app.sh"
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-pam-cgroups-quota.sh"
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-selinux-system.sh"
ssh root@${NODENAME} "cd ${GITDIR} ; sh node-ssh-proxy-app.sh"

