#!/bin/bash
# Test Broker Setup

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
echo "  services: mdns http dns dhcpv6-client ssh https"
echo "  ports: 5672/tcp"
echo "  forward-ports: "
echo "  icmp-blocks: "
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
echo "  === hit return to test sshd ==="
read testinput
/usr/bin/systemctl status sshd.service

echo " "
echo "  === hit return to test named ==="
read testinput
/bin/systemctl status named.service

echo " "
echo "  === hit return to test qpid ==="
read testinput
/usr/bin/systemctl status qpidd.service

echo " "
echo "  === hit return to test httpd ==="
read testinput
/usr/bin/systemctl status httpd.service

echo " "
echo "  === hit return to test mongod ==="
read testinput
/usr/bin/systemctl status mongod.service

echo " "
echo "  === hit return to test openshift-broker ==="
read testinput
/usr/bin/systemctl status openshift-broker.service

echo " "
echo "Done with service checking section"
echo " "


# Test broker rest api
echo " "
echo "  === hit return to test broker rest api ==="
read testinput
echo "Testing Broker rest api"
echo "  output should look sortof like this"
echo "  === begin cut here === "
echo "{\"data\":{\"API\":{\"href\":\"https://localhost/broker/rest/api\",\"method\":\"GET\",\"optional_params\":[],\"rel\":\"API entry point\",\"required_params\":[]},\"GET_ENVIRONMENT"
echo "..."
echo "supported_api_versions\":[1.0,1.1,1.2,1.3],\"type\":\"links\",\"version\":\"1.3\"}"
echo "  === end cut here === "

curl -k -u demo:demo https://localhost/broker/rest/api
echo " "
echo "  === hit return to continue to next test ==="
read testinput

