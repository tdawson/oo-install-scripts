#!/bin/bash
# Setup selinux and system control settings

#Setup SELINUX Booleans
setsebool -P httpd_unified=on httpd_can_network_connect=on httpd_can_network_relay=on httpd_read_user_content=on httpd_enable_homedirs=on httpd_run_stickshift=on allow_polyinstantiation=on

# Update selinux file settings
restorecon -rv /var/run
restorecon -rv /usr/sbin/mcollectived /var/log/mcollective.log /var/run/mcollectived.pid
restorecon -rv /var/lib/openshift /etc/openshift/node.conf /etc/httpd/conf.d/openshift

#SYSTEM CONTROL SETTINGS
echo "# Added for OpenShift" >> /etc/sysctl.d/openshift.conf
echo "kernel.sem = 250  32000 32  4096" >> /etc/sysctl.d/openshift.conf
echo "net.ipv4.ip_local_port_range = 15000 35530" >> /etc/sysctl.d/openshift.conf
echo "net.netfilter.nf_conntrack_max = 1048576" >> /etc/sysctl.d/openshift.conf
sysctl -p /etc/sysctl.d/openshift.conf

