#!/bin/bash
# avoid clock skew
yum -y install ntp
/bin/systemctl enable ntpd.service
/bin/systemctl start  ntpd.service
