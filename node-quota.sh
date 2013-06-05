#!/bin/bash
# Setup user disk quota on the node

# DISK QUOTA
#echo ""
#echo "Add usrquota to filesystem"
#echo "  add usrquota to whichever filesystem has /var/lib/openshift on it"
#echo "    Example:"
#echo "      /dev/sda1 / ext4    defaults,usrquota 1 1"
#echo ""
#echo "  Hit enter to begin editing fstab with vi"
#read tempkey
#vi /etc/fstab
/bin/cp -f /etc/fstab /etc/fstab.save.openshift
FS=`df /var/lib | grep -v Filesystem | awk '{print $6}'`
sed -i "s|^\S*\s\+${FS}\s\+\S*\s\+|&usrquota,|" /etc/fstab

# reboot or remount
mount -o remount /

# test
quotacheck -cmug /

