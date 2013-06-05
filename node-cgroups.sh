#!/bin/bash
# Setup Cgroups on the node

# CGROUPS
# Cgroups Config - Need to still fixup the cgroup configurations
# Cgroups enable and startup services

/bin/systemctl enable cgconfig.service
/bin/systemctl enable cgred.service
/usr/sbin/chkconfig openshift-cgroups on
/bin/systemctl restart  cgconfig.service
/bin/systemctl restart  cgred.service
/usr/sbin/service openshift-cgroups restart

