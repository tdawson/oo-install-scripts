#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# setup dhcp client
echo "prepend domain-name-servers ${BROKERIP};" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede host-name \"${BROKERNAME}\";" >> /etc/dhcp/dhclient-eth0.conf
echo "supersede domain-name \"${DOMAIN}\";" >> /etc/dhcp/dhclient-eth0.conf

NSFILE="/etc/sysconfig/network-scripts/ifcfg-eth0"
if [ -f $NSFILE ] ; then
	if grep -q PEERDNS $NSFILE ; then
		sed -i 's/PEERDNS=.*/PEERDNS=\"no\"/' $NSFILE
	else
		echo PEERDNS=\"no\" >> $NSFILE
	fi
	if grep -q DNS1 $NSFILE ; then
		sed -i "s/DNS1=.*/DNS1=${BROKERIP}" $NSFILE
	else
		echo DNS1=${BROKERIP} >> $NSFILE
	fi
fi

