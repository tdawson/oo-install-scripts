#!/bin/bash
# Setup DNS for the cluster
# This script currently only does Bind

# setup variables
source ./oo-install.conf

# install software
yum -y install openshift-origin-msg-node-mcollective mcollective-qpid-plugin

#Move original configuration out of the way
mv /etc/mcollective/server.cfg /etc/mcollective/server.cfg.orig

#Create new configuration
cat <<EOF > /etc/mcollective/server.cfg
topicprefix = /topic/
main_collective = mcollective
collectives = mcollective
libdir = /usr/libexec/mcollective
logfile = /var/log/mcollective.log
loglevel = debug
daemonize = 1
direct_addressing = n

# Plugins
securityprovider = psk
plugin.psk = unset
connector = qpid
plugin.qpid.host=${BROKERHOSTNAME}
plugin.qpid.secure=false
plugin.qpid.timeout=5

# Facts
factsource = yaml
plugin.yaml = /etc/mcollective/facts.yaml
EOF

# Setup and start services
/bin/systemctl enable mcollective.service
/bin/systemctl start  mcollective.service

