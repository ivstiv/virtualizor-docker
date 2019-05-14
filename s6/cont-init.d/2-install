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

echo "1) Installing Libraries and Dependencies" >> $LOG 2>&1

		apt-get update -y >> $LOG 2>&1
		apt-get install -y kpartx gcc openssl unzip sendmail make cron fuse e2fsprogs >> $LOG 2>&1

#----------------------------------
# Install PHP, MySQL, Web Server
#----------------------------------

echo "2) Installing PHP, MySQL and Web Server"

# Stop all the services of EMPS if they were there.
/usr/local/emps/bin/mysqlctl stop >> $LOG 2>&1
/usr/local/emps/bin/nginxctl stop >> $LOG 2>&1
/usr/local/emps/bin/fpmctl stop >> $LOG 2>&1

# Remove the EMPS package
rm -rf /usr/local/emps/ >> $LOG 2>&1

# The necessary folders
mkdir /usr/local/emps >> $LOG 2>&1
mkdir /usr/local/virtualizor >> $LOG 2>&1

echo "1) Installing PHP, MySQL and Web Server" >> $LOG 2>&1
wget -N -O /usr/local/virtualizor/EMPS.tar.gz "http://files.softaculous.com/emps.php?arch=$ARCH" >> $LOG 2>&1

# Extract EMPS
tar -xvzf /usr/local/virtualizor/EMPS.tar.gz -C /usr/local/emps >> $LOG 2>&1
rm -rf /usr/local/virtualizor/EMPS.tar.gz >> $LOG 2>&1

#----------------------------------
# Download and Install Virtualizor
#----------------------------------

echo "3) Downloading and Installing Virtualizor"
echo "3) Downloading and Installing Virtualizor" >> $LOG 2>&1

# Get our installer
wget -O /usr/local/virtualizor/install.php $FILEREPO/install.inc >> $LOG 2>&1

# Run our installer
/usr/local/emps/bin/php -d zend_extension=/usr/local/emps/lib/php/ioncube_loader_lin_5.3.so /usr/local/virtualizor/install.php master=1 email="$EMAIL"
rm -rf /usr/local/virtualizor/install.php >> $LOG 2>&1
rm -rf /usr/local/virtualizor/upgrade.php >> $LOG 2>&1

# Fix permissions

groupmod -o -g "$PGID" emps > /dev/null 2>&1
usermod -o -u "$PUID" emps > /dev/null 2>&1
groupmod -o -g "$PGID" mysql > /dev/null 2>&1
usermod -o -u "$PUID" mysql > /dev/null 2>&1

chown -R emps:emps /usr/local/emps/

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

echo "Thank you for choosing Softaculous Virtualizor !"
