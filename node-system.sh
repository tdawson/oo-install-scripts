#!/bin/bash
# Setup system control settings on the node

#SYSTEM CONTROL SETTINGS
echo "# Added for OpenShift" >> /etc/sysctl.d/openshift.conf
echo "kernel.sem = 250  32000 32  4096" >> /etc/sysctl.d/openshift.conf
echo "net.ipv4.ip_local_port_range = 15000 35530" >> /etc/sysctl.d/openshift.conf
echo "net.netfilter.nf_conntrack_max = 1048576" >> /etc/sysctl.d/openshift.conf
sysctl -p /etc/sysctl.d/openshift.conf

