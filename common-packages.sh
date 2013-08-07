#!/bin/bash
# install some basic packages
source ./oo-install.conf

if [ "$DISTRO" == "rhel6" ] ; then
    yum -y install ntp git which policycoreutils system-config-firewall-base
else
    yum -y install ntp git which policycoreutils firewalld 
fi


