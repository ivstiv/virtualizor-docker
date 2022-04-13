#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Flush the IP Tables
#iptables -F >> /dev/null 2>&1
#iptables -P INPUT ACCEPT >> /dev/null 2>&1

FILEREPO=http://files.virtualizor.com
LOG=/root/virtualizor.log

ARCH=64

echo "-----------------------------------------------"
echo " Welcome to Softaculous Virtualizor Installer"
echo "-----------------------------------------------"
echo " "


#----------------------------------
# Install some LIBRARIES
#----------------------------------
echo "1) Installing Libraries and Dependencies"


#----------------------------------
# Install PHP, MySQL, Web Server
#----------------------------------
echo "2) Installing PHP, MySQL and Web Server"

# Stop all the services of EMPS if they were there.
/usr/local/emps/bin/mysqlctl stop
/usr/local/emps/bin/nginxctl stop
/usr/local/emps/bin/fpmctl stop

# Remove the EMPS package
rm -rf /usr/local/emps/

# The necessary folders
mkdir /usr/local/emps
mkdir /usr/local/virtualizor


echo "1) Installing PHP, MySQL and Web Server"
wget -q --show-progress --progress=bar:force -O /usr/local/virtualizor/EMPS.tar.gz "http://files.softaculous.com/emps.php?latest=1&arch=$ARCH"

# Extract EMPS
tar -xvzf /usr/local/virtualizor/EMPS.tar.gz -C /usr/local/emps
rm -rf /usr/local/virtualizor/EMPS.tar.gz


#----------------------------------
# Download and Install Virtualizor
#----------------------------------
echo "3) Downloading and Installing Virtualizor"

# Get our installer
wget -q --show-progress --progress=bar:force -O /usr/local/virtualizor/install.php $FILEREPO/install.inc

echo "running the installer"
# Run our installer
/usr/local/emps/bin/php -d zend_extension=/usr/local/emps/lib/php/ioncube_loader_lin_5.3.so /usr/local/virtualizor/install.php email="$EMAIL"
phpret=$?
rm -rf /usr/local/virtualizor/install.php >> $LOG 2>&1
rm -rf /usr/local/virtualizor/upgrade.php >> $LOG 2>&1

# Was there an error
if ! [ $phpret == "8" ]; then
	echo " "
	echo "ERROR :"
	echo "There was an error while installing Virtualizor"
	echo "Please check /root/virtualizor.log for errors"
	echo "Exiting Installer"	
 	exit 1;
fi

#----------------------------------
# Starting Virtualizor Services
#----------------------------------
echo "Starting Virtualizor Services" >> $LOG 2>&1
/etc/init.d/virtualizor restart >> $LOG 2>&1

wget -O /tmp/ip.php http://softaculous.com/ip.php >> $LOG 2>&1 
ip=$(cat /tmp/ip.php)
rm -rf /tmp/ip.php

echo " "
echo "-------------------------------------"
echo " Installation Completed "
echo "-------------------------------------"
echo "Congratulations, Virtualizor has been successfully installed"
echo " "
/usr/local/emps/bin/php -r 'define("VIRTUALIZOR", 1); include("/usr/local/virtualizor/universal.php"); echo "API KEY : ".$globals["key"]."\nAPI Password : ".$globals["pass"];'
echo " "
echo " "
echo "You can login to the Virtualizor Admin Panel"
echo "using your ROOT details at the following URL :"
echo "https://$ip:4085/"
echo "OR"
echo "http://$ip:4084/"
echo " "
echo "You will need to reboot this machine to load the correct kernel"
echo -n "Do you want to reboot now ? [y/N]"
read rebBOOT

echo "Thank you for choosing Softaculous Virtualizor !"

if ([ "$rebBOOT" == "Y" ] || [ "$rebBOOT" == "y" ]); then	
	echo "The system is now being RESTARTED"
	reboot;
fi