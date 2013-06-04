#!/bin/bash
# Setup ssh, port-proxy, and the node-app

# setup variables
source ./oo-install.conf

# SSH
#echo ""
#echo "Tweak sshd config file"
#echo "  Add the following at the end of the AcceptEnv section"
#echo "    AcceptEnv GIT_SSH"
#read tempkey
#vi /etc/ssh/sshd_config

if grep -q "GIT_SSH" /etc/ssh/sshd_config ; then
    echo "  sshd_config is already correct"
else
    echo "  Fixing up sshd_config"
    sed -i -e 's|AcceptEnv XMODIFIERS|AcceptEnv XMODIFIERS GIT_SSH|g' /etc/ssh/sshd_config
fi

perl -p -i -e "s/^#MaxSessions .*$/MaxSessions 40/" /etc/ssh/sshd_config
perl -p -i -e "s/^#MaxStartups .*$/MaxStartups 40/" /etc/ssh/sshd_config

/bin/systemctl restart  sshd.service

#PORT PROXY

firewall-cmd --add-port=35531-65535/tcp
firewall-cmd --permanent --add-port=35531-65535/tcp
firewall-cmd --list-all

/bin/systemctl enable openshift-port-proxy.service
/bin/systemctl restart  openshift-port-proxy.service

# Node application setup

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

