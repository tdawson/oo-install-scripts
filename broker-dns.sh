#!/bin/bash
# Setup DNS for the cluster
# This script currently only does Bind

# setup variables
source oo-install.conf
KEYFILE=/var/named/${DOMAIN}.key

# install software
yum -y install bind bind-utils

# setup DNSSEC key pair
cd /var/named/
dnssec-keygen -a HMAC-MD5 -b 512 -n USER -r /dev/urandom ${DOMAIN}
KEY="$(grep Key: K${DOMAIN}*.private | cut -d ' ' -f 2)"
cd -
rndc-confgen -a -r /dev/urandom
echo $KEY

# setup permissions for the DNSSEC key pair
restorecon -v /etc/rndc.* /etc/named.*
chown -v root:named /etc/rndc.key
chmod -v 640 /etc/rndc.key

# setup forwarders
echo "forwarders { 8.8.8.8; 8.8.4.4; } ;" >> /var/named/forwarders.conf
restorecon -v /var/named/forwarders.conf
chmod -v 755 /var/named/forwarders.conf

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

# Check the key and database
echo "/var/named/dynamic/${DOMAIN}.db"
cat /var/named/dynamic/${DOMAIN}.db
echo ""
echo "${KEYFILE}"
cat ${KEYFILE}

# Set permissions for key and database
chown -Rv named:named /var/named
restorecon -rv /var/named

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

# Check the named file
echo ""
echo "/etc/named.conf"
cat /etc/named.conf

# setup permissions of named config file
chown -v root:named /etc/named.conf
restorecon /etc/named.conf

# Setup firewall
firewall-cmd --add-service=dns
firewall-cmd --permanent --add-service=dns
firewall-cmd --list-all

# Setup and start service
/bin/systemctl enable named.service
/bin/systemctl start named.service

# add entries using nsupdate
echo "You need to cut and paste the following at the prompt"
echo "=====start cut below this line===="
echo "server 127.0.0.1
echo "update delete ${BROKERHOSTNAME} A
echo "update add ${BROKERHOSTNAME} 180 A ${BROKERIP} )
echo "send
echo "quit
echo "=====end cut above this line===="
nsupdate -k ${KEYFILE}

# test DNS server
# This is best done before hostname has been set.
ping ${BROKERHOSTNAME}
dig @127.0.0.1 ${BROKERHOSTNAME}


