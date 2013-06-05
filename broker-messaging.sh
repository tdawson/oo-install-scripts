#!/bin/bash
# Setup messaging
# At current time activemq is not working on F19, so we are using qpid

# Install software
yum -y install mcollective-qpid-plugin qpid-cpp-server

# Setup firewall
firewall-cmd --add-port=5672/tcp
firewall-cmd --permanent --add-port=5672/tcp
firewall-cmd --list-all

# Setup and start service
/usr/bin/systemctl enable qpidd.service
/usr/bin/systemctl start qpidd.service

