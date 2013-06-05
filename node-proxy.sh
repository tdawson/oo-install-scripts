#!/bin/bash
# Setup port-proxy on the node

# setup variables
source ./oo-install.conf

#PORT PROXY

firewall-cmd --add-port=35531-65535/tcp
firewall-cmd --permanent --add-port=35531-65535/tcp
firewall-cmd --list-all

/bin/systemctl enable openshift-port-proxy.service
/bin/systemctl restart  openshift-port-proxy.service

