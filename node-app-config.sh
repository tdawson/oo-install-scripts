#!/bin/bash
# Setup the node-application

# setup variables
source ./oo-install.conf

# Node application setup
/bin/systemctl enable httpd.service
/bin/systemctl enable openshift-gears.service

#echo ""
#echo "Tweak node config file"
#echo "  Make sure the settings are set to these values"
#echo "    PUBLIC_HOSTNAME=\"${NODEHOSTNAME}\""
#echo "    PUBLIC_IP=\"${NODEIP}\""
#echo "    BROKER_HOST=\"${BROKERIP}\""
#echo "    CLOUD_DOMAIN=\"${DOMAIN}\""
#read tempkey
#vi /etc/openshift/node.conf

if grep -q "PUBLIC_HOSTNAME=\"${NODEHOSTNAME}\"" /etc/openshift/node.conf ; then
  echo "  PUBLIC_HOSTNAME is correct"
else 
  echo "  Fixing up PUBLIC_HOSTNAME"
  sed -i -e "s|PUBLIC_HOSTNAME=.*$|PUBLIC_HOSTNAME=\"${NODEHOSTNAME}\"|g" /etc/openshift/node.conf
fi
if grep -q "PUBLIC_IP=\"${NODEIP}\"" /etc/openshift/node.conf ; then
  echo "  PUBLIC_IP is correct"
else 
  echo "  Fixing up PUBLIC_IP"
  sed -i -e "s|PUBLIC_IP=.*$|PUBLIC_IP=\"${NODEIP}\"|g" /etc/openshift/node.conf
fi
if grep -q "BROKER_HOST=\"${BROKERIP}\"" /etc/openshift/node.conf ; then
  echo "  BROKER_HOST is correct"
else 
  echo "  Fixing up BROKER_HOST"
  sed -i -e "s|BROKER_HOST=.*$|BROKER_HOST=\"${BROKERIP}\"|g" /etc/openshift/node.conf
fi
if grep -q "CLOUD_DOMAIN=\"${DOMAIN}\"" /etc/openshift/node.conf ; then
  echo "  CLOUD_DOMAIN is correct"
else 
  echo "  Fixing up CLOUD_DOMAIN"
  sed -i -e "s|CLOUD_DOMAIN=.*$|CLOUD_DOMAIN=\"${DOMAIN}\"|g" /etc/openshift/node.conf
fi

/etc/cron.minutely/openshift-facts

