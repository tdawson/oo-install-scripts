#!/bin/bash
# avoid clock skew
# setup variables
source ./oo-install.conf

yum -y install ntp

if [ "$DISTRO" == "rhel6" ] ; then
    chkconfig ntpd on
    service ntpd start
else
    systemctl enable ntpd.service
    systemctl start  ntpd.service
fi


