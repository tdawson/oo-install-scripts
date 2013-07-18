#!/bin/bash
# Setup yum repos for broker

# setup variables
source ./oo-install.conf

# Setup the release variable
if [ "$DISTRO" == "fedora18" ] ; then
	RELEASE="fedora-18"
elif [ "$DISTRO" == "fedora19" ] ; then
	RELEASE="fedora-19"
elif [ "$DISTRO" == "fedora20" ] ; then
	RELEASE="fedora-20"
elif [ "$DISTRO" == "rhel6" ] ; then
	RELEASE="rhel-6"
else
	echo "Your distro is not supported.  Exiting ..."
	exit 1
fi

# Setup the main and dependancy repo URLS
DEPURL="https://mirror.openshift.com/pub/openshift-origin/$RELEASE/$ARCH/"
if [ "$OPENSHIFT_SOURCE" == "nightly" ] ; then
	MAINURL="https://mirror.openshift.com/pub/openshift-origin/nightly/$RELEASE/latest/$ARCH/"
elif [ "$OPENSHIFT_SOURCE" == "v1" ] ; then
	if [ "$ARCH" == "x86_64" ] ; then
		if [ "$DISTRO" == "rhel6" ] || [ "$DISTRO" == "fedora18" ]  ; then
			MAINURL="https://mirror.openshift.com/pub/openshift-origin/release/1/$RELEASE/packages/$ARCH/"
			DEPURL="https://mirror.openshift.com/pub/openshift-origin/release/1/$RELEASE/dependancies/$ARCH/"
		else
			echo "Release v1 only supports rhel6 and fedora18, not $DISTRO.  Exiting ..."
			exit 2
		fi
	else
		echo "Release v1 only supports x86_64, not $ARCH.  Exiting ..."
		exit 3
	fi
elif [ "$OPENSHIFT_SOURCE" == "distro" ] ; then
	echo "There is no need to setup the yum repo if your souce is distro.  Exiting ..."
	exit 4
else
	echo "Your yum source is not supported.  Exiting ..."
	exit 5
fi

# Move old repo out of the way if it's there
if [ -f /etc/yum.repos.d/openshift-origin.repo ] ; then
	mv -f /etc/yum.repos.d/openshift-origin.repo /etc/yum.repos.d/openshift-origin.repo.save
fi

# Create our new repo file
cat <<EOF > /etc/yum.repos.d/openshift-origin.repo
[openshift-origin]
name=OpenShift Origin $OPENSHIFT_SOURCE $ARCH
baseurl=$MAINURL
enabled=1
metadata_expire=1d
gpgcheck=0

[openshift-origin-deps]
name=OpenShift Origin Dependancies $OPENSHIFT_SOURCE $ARCH
baseurl=$DEPURL
enabled=1
metadata_expire=1d
gpgcheck=0

EOF


