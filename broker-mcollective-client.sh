#!/bin/bash
# Setup mcollective client
# This is setting up for QPID
# Change this if working with activemq

# setup variables
source oo-install.conf

# install software
yum -y install mcollective-client

# Move old config out of the way
mv /etc/mcollective/client.cfg /etc/mcollective/client.cfg.orig

# Create new client config file
cat <<EOF > /etc/mcollective/client.cfg
topicprefix = /topic/
main_collective = mcollective
collectives = mcollective
libdir = /usr/libexec/mcollective
loglevel = debug
logfile = /var/log/mcollective-client.log

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

