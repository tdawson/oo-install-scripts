#!/bin/bash
# Setup pam on the node

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

