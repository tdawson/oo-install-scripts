#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# setup dhcp client
echo "prepend domain-name-servers ${BROKERIP};" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede host-name \"${BROKERNAME}\";" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede domain-name \"${DOMAIN}\";" >> /etc/dhcp/dhclient-eth0.conf

# setup hostname
echo "${BROKERHOSTNAME}" > /etc/hostname

