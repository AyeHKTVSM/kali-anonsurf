#!/bin/bash

# Ensure we are being ran as root
if [ $(id -u) -ne 0 ]; then
	echo "This script must be ran as root"
	exit 1
fi

# For upgrades and sanity check, remove any existing i2p.list file
rm -f /etc/apt/sources.list.d/i2p.list

# Compile the i2p ppa
 echo "deb [signed-by=/usr/share/keyrings/i2p-archive-keyring.gpg] https://deb.i2p2.de/ $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/i2p.list
    curl -o i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg
      sudo cp i2p-archive-keyring.gpg /usr/share/keyrings
apt-get update # Update repos

if [[ -n $(cat /etc/os-release |grep kali) ]]
then
	apt-get install libservlet3.1-java libecj-java libgetopt-java glassfish-javaee ttf-dejavu i2p i2p-router libjbigi-jni libjetty8-java #installs i2p and other dependencies
	apt-get -f install # resolves anything else in a broken state
fi

apt-get install -y apt-transport-https lsb-release curl
apt-get install -y i2p-keyring #this will ensure you get updates to the repository's GPG key
apt-get install -y secure-delete tor i2p i2p-keyring # install dependencies, just in case

# Configure and install the .deb
dpkg-deb -b kali-anonsurf-deb-src/ kali-anonsurf.deb # Build the deb package
dpkg -i kali-anonsurf.deb || (apt-get -f install && dpkg -i kali-anonsurf.deb) # this will automatically install the required packages

exit 0
