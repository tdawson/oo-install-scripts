#!/bin/bash
# Setup dhcp client on the node

# setup variables
source ./oo-install.conf

# setup dhcp client
echo "prepend domain-name-servers ${BROKERIP};" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede host-name \"${NODENAME}\";" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede domain-name \"${DOMAIN}\";" >> /etc/dhcp/dhclient-eth0.conf

