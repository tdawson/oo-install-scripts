#!/bin/bash
# Setup ssh on the node

# setup variables
source ./oo-install.conf

# SSH
#echo ""
#echo "Tweak sshd config file"
#echo "  Add the following at the end of the AcceptEnv section"
#echo "    AcceptEnv GIT_SSH"
#read tempkey
#vi /etc/ssh/sshd_config

if grep -q "GIT_SSH" /etc/ssh/sshd_config ; then
    echo "  sshd_config is already correct"
else
    echo "  Fixing up sshd_config"
    sed -i -e 's|AcceptEnv XMODIFIERS|AcceptEnv XMODIFIERS GIT_SSH|g' /etc/ssh/sshd_config
fi

perl -p -i -e "s/^#MaxSessions .*$/MaxSessions 40/" /etc/ssh/sshd_config
perl -p -i -e "s/^#MaxStartups .*$/MaxStartups 40/" /etc/ssh/sshd_config

/bin/systemctl restart  sshd.service

