#!/bin/bash
# Setup selinux on the node

#Setup SELINUX Booleans
setsebool -P httpd_unified=on httpd_can_network_connect=on httpd_can_network_relay=on httpd_read_user_content=on httpd_enable_homedirs=on httpd_run_stickshift=on allow_polyinstantiation=on

# Update selinux file settings
restorecon -rv /var/run
restorecon -rv /usr/sbin/mcollectived /var/log/mcollective.log /var/run/mcollectived.pid
restorecon -rv /var/lib/openshift /etc/openshift/node.conf /etc/httpd/conf.d/openshift

