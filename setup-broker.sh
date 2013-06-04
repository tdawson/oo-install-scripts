#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# Update to latest packages
yum -y update

# Make sure date and time are correct
sh date-time.sh

sh broker-dns.sh
sh broker-dhcp-hostname.sh
sh broker-mongodb.sh
sh broker-messaging.sh
sh broker-mcollective-client.sh
sh broker-broker-app.sh
sh broker-plugins-accounts.sh

