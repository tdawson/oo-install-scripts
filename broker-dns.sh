#!/bin/bash
# Setup DNS for the cluster
# This script currently only does Bind

# setup variables
source ./oo-install.conf

# install software
yum -y install bind bind-utils openshift-origin-broker-util

# setup DNSSEC key pair
cd /var/named/
rm -f K${DOMAIN}*
dnssec-keygen -a HMAC-MD5 -b 512 -n USER -r /dev/urandom ${DOMAIN}
KEY="$(grep Key: K${DOMAIN}*.private | cut -d ' ' -f 2)"
cd -
echo $KEY
rndc-confgen -a -r /dev/urandom

# setup permissions for the DNSSEC key pair
restorecon -v /etc/rndc.* /etc/named.*
chown -v root:named /etc/rndc.key
chmod -v 640 /etc/rndc.key

# setup forwarders
echo "forwarders { 8.8.8.8; 8.8.4.4; } ;" >> /var/named/forwarders.conf
restorecon -v /var/named/forwarders.conf
chmod -v 640 /var/named/forwarders.conf

# setup initial DNS database
rm -rvf /var/named/dynamic
mkdir -vp /var/named/dynamic

cat <<EOF > /var/named/dynamic/${DOMAIN}.db
\$ORIGIN .
\$TTL 1	; 1 seconds (for testing only)
${DOMAIN} IN SOA ns1.${DOMAIN}. hostmaster.${DOMAIN}. (
                         2011112904 ; serial
                         60         ; refresh (1 minute)
                         15         ; retry (15 seconds)
                         1800       ; expire (30 minutes)
                         10         ; minimum (10 seconds)
                          )
                     NS ns1.${DOMAIN}.
                     MX 10 mail.${DOMAIN}.
\$ORIGIN ${DOMAIN}.
ns1	              A        127.0.0.1

EOF

# Install the DNSSEC key
cat <<EOF > ${KEYFILE}
key ${DOMAIN} {
  algorithm HMAC-MD5;
  secret "${KEY}";
};
EOF

# Set permissions for key and database
chown -Rv named:named /var/named
restorecon -rv /var/named

# Check the key and database
echo "/var/named/dynamic/${DOMAIN}.db"
cat /var/named/dynamic/${DOMAIN}.db
echo ""
echo "${KEYFILE}"
cat ${KEYFILE}

# Create the named configuration file
mv /etc/named.conf /etc/named.conf.openshift
cat <<EOF > /etc/named.conf
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
    listen-on port 53 { any; };
    directory "/var/named";
    dump-file "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query { any; };
    recursion yes;

    /* Path to ISC DLV key */
    bindkeys-file "/etc/named.iscdlv.key";

    // set forwarding to the next nearest server (from DHCP response
    forward only;
    include "forwarders.conf";
};

logging {
    channel default_debug {
        file "data/named.run";
        severity dynamic;
    };
};

// use the default rndc key
include "/etc/rndc.key";
 
controls {
    inet 127.0.0.1 port 953
    allow { 127.0.0.1; } keys { "rndc-key"; };
};

include "/etc/named.rfc1912.zones";

include "${DOMAIN}.key";

zone "${DOMAIN}" IN {
    type master;
    file "dynamic/${DOMAIN}.db";
    allow-update { key ${DOMAIN} ; } ;
};
EOF

# setup permissions of named config file
chown -v root:named /etc/named.conf
restorecon /etc/named.conf

# Check the named file
echo ""
echo "/etc/named.conf"
cat /etc/named.conf

# Add us at the beginning of the resolve.conf file
if ! grep -q 127.0.0.1 /etc/resolv.conf ; then
    sed -i 's/^/nameserver 127.0.0.1/' /etc/resolve.conf
fi

if [ "$DISTRO" == "rhel6" ] ; then
    # Setup firewall
    lokkit --service=dns
    # Setup and start service
    chkconfig named on
    service named start
else
    # Setup firewall
    firewall-cmd --add-service=dns
    firewall-cmd --permanent --add-service=dns
    # Setup and start service
    systemctl enable named.service
    systemctl start named.service
fi



## add entries using nsupdate
#echo "You need to cut and paste the following at the prompt"
#echo "=====start cut below this line===="
#echo "server 127.0.0.1 "
#echo "update delete ${BROKERHOSTNAME} A "
#echo "update add ${BROKERHOSTNAME} 180 A ${BROKERIP} "
#echo "send "
#echo "quit "
#echo "=====end cut above this line===="
#nsupdate -k ${KEYFILE}
oo-register-dns -s 127.0.0.1 -h ${BROKERNAME} -d ${DOMAIN} -n ${BROKERIP} -k ${KEYFILE}


