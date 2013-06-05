#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source ./oo-install.conf

# install software
# rubygem-psych requirement might go away
yum -y install rubygem-psych rubygem-mocha

# Create config files from examples
cp /usr/share/gems/gems/openshift-origin-auth-remote-user-*/conf/openshift-origin- auth-remote-user.conf.example /etc/openshift/plugins.d/openshift-origin-auth-remote-user.conf
cp /etc/openshift/plugins.d/openshift-origin-msg-broker-mcollective.conf.example /etc/openshift/plugins.d/openshift-origin-msg-broker-mcollective.conf

# Config the DNS profile
cd /var/named/
KEY="$(grep Key: K${DOMAIN}*.private | cut -d ' ' -f 2)"

cat <<EOF > /etc/openshift/plugins.d/openshift-origin-dns-bind.conf
BIND_SERVER="127.0.0.1"
BIND_PORT=53
BIND_KEYNAME="${DOMAIN}"
BIND_KEYVALUE="${KEY}"
BIND_ZONE="${DOMAIN}"
EOF

# Configure authentication plugin and add a user
cp -v /var/www/openshift/broker/httpd/conf.d/openshift-origin-auth-remote-user-basic.conf.sample /var/www/openshift/broker/httpd/conf.d/openshift-origin-auth-remote-user.conf
htpasswd -c -b -s /etc/openshift/htpasswd demo demo

# Add Mongodb account
grep MONGO /etc/openshift/broker.conf
mongo openshift_broker_dev --eval 'db.addUser("openshift", "mooo")'

# Bundle broker gems
cd /var/www/openshift/broker
gem install mongoid
bundle --local

# Setup and start service
/usr/bin/systemctl enable openshift-broker.service
/usr/bin/systemctl start httpd.service
/usr/bin/systemctl start openshift-broker.service
/usr/bin/systemctl status openshift-broker.service

