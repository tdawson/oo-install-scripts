#!/bin/bash
# Test Node Setup

# setup variables
source ./oo-install.conf

# Firewall on Broker
echo "Testing Firewall"
echo "  Firewall output should look like this"
echo "  === begin cut here === "
echo "public"
echo "  interfaces: eth0"
echo "  services: mdns http dhcpv6-client https ssh"
echo "  ports: 35531-65535/tcp"
echo "  forward-ports: "
echo "  icmp-blocks: "
echo "  === end cut here === "
firewall-cmd --list-all
echo "  === hit return to continue to next test ==="
read testinput


