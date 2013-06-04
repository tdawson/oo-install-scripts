#!/bin/bash
# Setup ssh keys for authenticating from broker to node

# setup variables
source ./oo-install.conf

# Put node information in DNS
oo-register-dns -h ${NODENAME} -d ${DOMAIN} -n ${NODEIP} -k ${KEYFILE}

# Copy over broker pub key info
scp /etc/openshift/rsync_id_rsa.pub root@${NODEHOSTNAME}:/root/.ssh/

# Setup broker pub key for authentication
ssh root@${NODEHOSTNAME} "cat /root/.ssh/rsync_id_rsa.pub >> /root/.ssh/authorized_keys ; rm -f /root/.ssh/rsync_id_rsa.pub"

# Verify you can ssh in without password
ssh root@${NODEHOSTNAME} "hostname ; uptime"

