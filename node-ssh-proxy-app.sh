#!/bin/bash
# Setup ssh, port-proxy, and the node-app

# setup variables
source oo-install.conf

# SSH
echo ""
echo "Tweak sshd config file"
echo "  Add the following at the end of the AcceptEnv section"
echo "    AcceptEnv GIT_SSH"
read tempkey
vi /etc/ssh/sshd_config

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

echo ""
echo "Tweak node config file"
echo "  Make sure the settings are set to these values"
echo "    PUBLIC_HOSTNAME=\"${NODEHOSTNAME}\""
echo "    PUBLIC_IP=\"${NODEIP}\""
echo "    BROKER_HOST=\"${BROKERIP}\""
echo "    CLOUD_DOMAIN=\"${DOMAIN}\""
read tempkey
vi /etc/openshift/node.conf

/etc/cron.minutely/openshift-facts

