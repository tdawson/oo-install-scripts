#!/bin/bash
# Setup DNS for the cluster
# This script currently only does Bind

# PAM
sed -i -e 's|pam_selinux|pam_openshift|g' /etc/pam.d/sshd

for f in "runuser" "runuser-l" "sshd" "su" "system-auth-ac"
do
  t="/etc/pam.d/$f"
  if ! grep -q "pam_namespace.so" "$t"
  then
    echo -e "session\t\trequired\tpam_namespace.so no_unmount_on_close" >> "$t"
  fi
done

# CGROUPS
# Cgroups Config - Need to still fixup the cgroup configurations
# Cgroups enable and startup services

/bin/systemctl enable cgconfig.service
/bin/systemctl enable cgred.service
/usr/sbin/chkconfig openshift-cgroups on
/bin/systemctl restart  cgconfig.service
/bin/systemctl restart  cgred.service
/usr/sbin/service openshift-cgroups restart

# DISK QUOTA
echo ""
echo "Add usrquota to filesystem"
echo "  add usrquota to whichever filesystem has /var/lib/openshift on it"
echo "    Example:"
echo "      /dev/sda1 / ext4    defaults,usrquota 1 1"
read tempkey
vi /etc/fstab

# reboot or remount
mount -o remount /
quotacheck -cmug /

