oo-install-scripts
==================

These are scripts and config files that allow you to install 
OpenShift Origin by hand, only scripted.

These scripts have currently been tested on an F19 OpenShift cluster 
that consists of one broker and one node.

For the tests we started with a F19 minimal install

======================
BROKER SETUP 
======================
(ON NODE)
nm-tool
== ON BROKER
yum -y install git
git clone git://github.com/tdawson/oo-install-scripts.git
nm-tool
cd oo-install-scripts/
vi oo-install.conf
> BROKERIP="192.168.122.220" (Put in the broker ip address)
> NODEIP="192.168.122.161" (Put in the node ip address)

======================
BROKER RUN SCRIPT 
(Full Automation)
======================
sh setup-broker.sh
reboot

======================
BROKER RUN SCRIPT 
(Hit return at each step)
======================
sh setup-broker.sh --slow
reboot

======================
NODE SETUP
======================
# ON BROKER
cd oo-install-scripts/
sh broker-node-auth-setup.sh

# ON NODE
yum -y install git
git clone git://github.com/tdawson/oo-install-scripts.git
cd oo-install-scripts/
vi oo-install.conf
> BROKERIP="192.168.122.220" (Put in the broker ip address)
> NODEIP="192.168.122.161" (Put in the node ip address)

======================
NODE RUN SCRIPT 
(Full Automation)
======================
sh setup-node.sh
reboot

======================
NODE RUN SCRIPT 
(Hit return at each step)
======================
sh setup-node.sh --slow
reboot

