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
if [ "$DISTRO" == "rhel6" ] ; then
    chkconfig mongod on
    service mongod start
else
    systemctl enable mongod.service
    systemctl start  mongod.service
fi

# Testing
# Uncomment this if you want to manually test
#echo ""
#echo "Testing that mongodb works"
#echo "  type in the following"
#echo "    show dbs"
#echo "    exit"
#echo "  Hit return to start"
#read tempkey
#mongo

