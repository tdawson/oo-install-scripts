#!/bin/bash
# Test Node Setup

# setup variables
source ./oo-install.conf

# Firewall on Broker
echo "  === hit return to test firewall ==="
read testinput
echo "Testing Firewall"
echo "  Firewall output should look like this"
echo "  === begin cut here === "
echo "public"
echo "  interfaces: eth0"
echo "  sources:"
echo "  services: mdns http dhcpv6-client https ssh"
echo "  ports: 35531-65535/tcp"
echo "  masquerade: no "
echo "  forward-ports: "
echo "  icmp-blocks: "
echo "  rich rules: "
echo "  === end cut here === "
firewall-cmd --list-all
echo "  === hit return to continue to next test ==="
read testinput

## Services
echo "Checking Services"
echo "  All services should be running without errors"

echo " "
echo "  === hit return to test ntpd ==="
read testinput
/usr/bin/systemctl status ntpd.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart ntpd.service"

echo " "
echo "  === hit return to test sshd ==="
read testinput
/usr/bin/systemctl status sshd.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart sshd.service"

echo " "
echo "  === hit return to test mcollective ==="
read testinput
/usr/bin/systemctl status mcollective.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart mcollective.service"

echo " "
echo "  === hit return to test httpd ==="
read testinput
/usr/bin/systemctl status httpd.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart httpd.service"

echo " "
echo "  === hit return to test cgred ==="
read testinput
/usr/bin/systemctl status cgred.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart cgred.service"

echo " "
echo "  === hit return to test cgconfig ==="
read testinput
/usr/bin/systemctl status cgconfig.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart cgconfig.service"

echo " "
echo "  === hit return to test openshift-gears ==="
read testinput
/usr/bin/systemctl status openshift-gears.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart openshift-gears.service"

echo " "
echo "  === hit return to test openshift-port-proxy ==="
read testinput
/usr/bin/systemctl status openshift-port-proxy.service
echo " "
echo " If this does not look correct, run the following to restart the service "
echo " /usr/bin/systemctl restart openshift-port-proxy.service"


echo " "
echo "Done with service checking section"
echo " "


