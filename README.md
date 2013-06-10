oo-install-scripts
==================

These are scripts and config files that allow you to install 
OpenShift Origin by hand, only scripted.

These scripts have currently been tested on an F19 OpenShift cluster 
that consists of one broker and one node.

For the tests we started with a F19 minimal install

NOTE: These scripts should be for testing purposes only.  They install known weak passwords as well as keys with no password.

======================
BROKER SETUP 
======================
(ON NODE)

nm-tool

(ON BROKER)

yum -y install git
  
git clone git://github.com/tdawson/oo-install-scripts.git

nm-tool

cd oo-install-scripts/

vi oo-install.conf

> BROKERIP="192.168.122.220" (Put in the broker ip address)

> NODEIP="192.168.122.161" (Put in the node ip address)

======================
BROKER RUN SCRIPT
======================

sh setup-broker.sh

or

sh setup-broker.sh --slow

reboot

======================
NODE SETUP
======================
The node can set setup either from the broker or from the node.

======================
NODE SETUP COMPLETELY FROM BROKER
======================

(ON BROKER) (After reboot)

ssh-agent bash

ssh-add /etc/openshift/rsync_id_rsa

cd oo-install-scripts/

sh setup-node-from-broker.sh

======================
NODE SETUP FROM NODE AND BROKER
======================

(ON BROKER) (After reboot)

ssh-agent bash

ssh-add /etc/openshift/rsync_id_rsa

cd oo-install-scripts/

sh broker-node-auth-setup.sh

(ON NODE)

yum -y install git
  
git clone git://github.com/tdawson/oo-install-scripts.git

nm-tool

cd oo-install-scripts/

vi oo-install.conf

> BROKERIP="192.168.122.220" (Put in the broker ip address)

> NODEIP="192.168.122.161" (Put in the node ip address)

sh setup-node.sh

or

sh setup-node.sh --slow

reboot


