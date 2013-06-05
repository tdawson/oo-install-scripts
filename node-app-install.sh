#!/bin/bash
# Install and initial setup of the node application

# install software
yum -y install rubygem-openshift-origin-node rubygem-passenger-native openshift-origin-port-proxy openshift-origin-node-util
yum -y install openshift-origin-cartridge-cron-1.4 openshift-origin-cartridge-diy-0.1

# Setup firewall
firewall-cmd --add-service=ssh
firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --list-all

