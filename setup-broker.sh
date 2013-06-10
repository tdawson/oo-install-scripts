#!/bin/bash
# Run all the scripts to setup a broker node

# setup variables
source ./oo-install.conf
if [ "$1" == "--slow" ] ; then
  SLOW="yes"
fi

if [ "$SLOW" == "yes" ] ; then
    echo "Yum Update"
    echo "  Hit Enter to continue"
    read testinput    
fi
yum -y update

if [ "$SLOW" == "yes" ] ; then
    echo "Setup date and time"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh common-date-time.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup DNS server"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-dns.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup host dhcp setting"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-dhcp.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Set hostname"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-hostname.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup mongodb"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-mongodb.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup messaging"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-messaging.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup mcollective client"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-mcollective-client.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup the broker application"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-broker-app.sh

if [ "$SLOW" == "yes" ] ; then
    echo "Setup plugins and accounts"
    echo "And then the final test"
    echo "  Hit Enter to continue"
    read testinput    
fi
sh broker-plugins-accounts.sh

