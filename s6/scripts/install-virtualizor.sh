#!/usr/bin/with-contenv bash
# shellcheck shell=bash

FILEREPO=http://files.virtualizor.com
ARCH=64

echo "-----------------------------------------------"
echo " Welcome to Softaculous Virtualizor Installer"
echo "-----------------------------------------------"
echo " "

echo "Updating packages..."
apt update
apt upgrade -y

# Stop all the services of EMPS if they were there.
[ -f /usr/local/emps/bin/mysqlctl ] && /usr/local/emps/bin/mysqlctl stop
[ -f /usr/local/emps/bin/nginxctl ] && /usr/local/emps/bin/nginxctl stop
[ -f /usr/local/emps/bin/fpmctl ] && /usr/local/emps/bin/fpmctl stop

# The necessary folders
[ ! -d /usr/local/emps ] && mkdir /usr/local/emps
[ ! -d /usr/local/virtualizor ] && mkdir /usr/local/virtualizor


echo "1) Installing PHP, MySQL and Web Server"
wget -q --show-progress --progress=bar:force -O /usr/local/virtualizor/EMPS.tar.gz "http://files.softaculous.com/emps.php?latest=1&arch=$ARCH"

# Extract EMPS
tar -xvzf /usr/local/virtualizor/EMPS.tar.gz -C /usr/local/emps
rm -rf /usr/local/virtualizor/EMPS.tar.gz


#----------------------------------
# Download and Install Virtualizor
#----------------------------------
echo "2) Downloading and Installing Virtualizor"
echo "Please be patient. This step can take a long time. Some warnings are expected."

# Get our installer
wget -q --show-progress --progress=bar:force -O /usr/local/virtualizor/install.php $FILEREPO/install.inc


# Run our installer
/usr/local/emps/bin/php -d zend_extension=/usr/local/emps/lib/php/ioncube_loader_lin_5.3.so /usr/local/virtualizor/install.php email="$EMAIL"
phpret=$?
rm -rf /usr/local/virtualizor/install.php
rm -rf /usr/local/virtualizor/upgrade.php

# Was there an error
if ! [ $phpret == "8" ]; then
	echo " "
	echo "ERROR :"
	echo "There was an error while installing Virtualizor"
	echo "Please check /root/virtualizor.log for errors"
	echo "Exiting Installer"	
 	exit 1;
fi

# Fix permissions
groupmod -o -g "$PGID" emps
usermod -o -u "$PUID" emps
groupmod -o -g "$PGID" mysql
usermod -o -u "$PUID" mysql

chown -R emps:emps /usr/local/emps/

#----------------------------------
# Starting Virtualizor Services
#----------------------------------
echo "Starting Virtualizor Services"
/etc/init.d/virtualizor restart

wget -O /tmp/ip.php http://softaculous.com/ip.php
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
echo "For ADMIN login, please use the following URL :"
echo "Username: root"
echo "Password: The password you set during the installation"
echo "https://$ip:443"
echo "OR"
echo "http://$ip:80"
echo " "
echo "For USER login, please use the following URL :"
echo "https://$ip:4083"
echo "OR"
echo "http://$ip:4082"
echo " "

echo "Thank you for choosing Softaculous Virtualizor !"