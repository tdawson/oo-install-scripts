#!/bin/bash
# Install and configure MongoDB

# install software
yum -y install mongodb-server

# Tweek config file
#echo ""
#echo "Tweak mongodb config file"
#echo "  Uncomment auth = true"
#echo "  Add smallfiles = true"
#echo "  Hit return to start"
#read tempkey
#vi /etc/mongodb.conf
sed -i -e 's|#auth = true|auth = true\nsmallfiles = true|g' /etc/mongodb.conf

# Setup and start service
/usr/bin/systemctl enable mongod.service
/usr/bin/systemctl start mongod.service
/usr/bin/systemctl status mongod.service

# Testing
echo ""
echo "Testing that mongodb works"
echo "  type in the following"
echo "    show dbs"
echo "    exit"
echo "  Hit return to start"
read tempkey
mongo

