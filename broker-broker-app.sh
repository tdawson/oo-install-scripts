#!/bin/bash
# Setup dhcp client and hostname

# setup variables
source oo-install.conf

# install software
yum -y install openshift-origin-broker openshift-origin-broker-util rubygem-openshift-origin-auth-remote-user rubygem-openshift-origin-msg-broker-mcollective rubygem-openshift-origin-dns-bind

# Modifying the broker proxy server name
sed -i -e "s/ServerName .*$/ServerName ${BROKERHOSTNAME}/" /etc/httpd/conf.d/000002_openshift_origin_broker_servername.conf 

# Setup and start service
/usr/bin/systemctl enable httpd.service
/usr/bin/systemctl enable ntpd.service
/usr/bin/systemctl enable sshd.service

# Setup Firewall
firewall-cmd --add-service=ssh
firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --list-all

# Generate access key
openssl genrsa -out /etc/openshift/server_priv.pem 2048
openssl rsa -in /etc/openshift/server_priv.pem -pubout > /etc/openshift/server_pub.pem
ssh-keygen -t rsa -b 2048 -f ~/.ssh/rsync_id_rsa
cp -v ~/.ssh/rsync_id_rsa* /etc/openshift/

# Setup selinux boolean variables and set file contexts
setsebool -P httpd_unified=on httpd_can_network_connect=on httpd_can_network_relay=on httpd_run_stickshift=on named_write_master_zones=on
fixfiles -R rubygem-passenger restore
fixfiles -R mod_passenger restore
restorecon -rv /var/run
restorecon -rv /usr/share/gems/gems/passenger-*

# Tweak broker config, if needed
echo ""
echo "Tweak broker config file"
echo "  Might not have to do anything but make sure you have the following lines"
echo "    CLOUD_DOMAIN=\"${DOMAIN}\""
echo "    VALID_GEAR_SIZES=\"small,medium\""
read tempkey
vi /etc/openshift/broker.conf

