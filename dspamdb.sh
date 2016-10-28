#!/bin/sh
#
# DSPAM install script for RHEL 5,6,7
# Written by Eric C. Broch of White Horse Technical Consulting, January 26, 2015
#
# Use this script at your own risk. If you do use it and the bottom drops out of
# your world, I will accept no responsibilty.
#
MYSQLPW=
dsstart="service dspam start"
dson="chkconfig dspam on"
dbstart="service mysqld start"
dbon="chkconfig mysqld on"
dbserv=mysql-server
pri=yum-priorities
# Check if release file is present
if [ ! -f /etc/redhat-release ]; then
   echo "Error getting EL release. Exiting..."
   exit 1
fi
release=`cat /etc/redhat-release | tr -d [:alpha:] | cut -d"." -f1 | tr -d ' '`
if  [ "$release" != "5" ]; then
   pri="yum-plugin-priorities"
fi

yum -y install $pri
if [ "$release" = "7" ]; then
   dsstart="systemctl start dspam"
   dson="systemctl enable dspam"
   dbstart="systemctl start mariadb"
   dbon="systemctl enable mariadb"
   dbserv=mariadb-server
fi

# Insall 
yum -y install $dbserv epel-release dspam dspam-client dspam-mysql wget
$dbon
$dbstart

# mysql secure install
read -p "Run MySQL Secure Installation [Y/N] : " yesno
if [ "$yesno" = "Y" ] || [ "$yesno" = "y" ]; then
   mysql_secure_installation
fi

# Get DB password for administrator and check validity.
if [ -z "$MYSQLPW" ]; then
   read -s -p "Enter $dbserv admin password to create dspam db: " MYSQLPW
fi
mysqladmin status -uroot -p$MYSQLPW > /dev/null 2>&1
if [ "$?" != "0" ]; then
   echo "Bad $dbserv administrator password. Exiting..."
   exit 1
fi

echo ""
echo "Destroying Dspam database..."
sleep 7
# Create dspam with correct permissions
mysqladmin drop dspam -uroot -p$MYSQLPW
mysqladmin create dspam -uroot -p$MYSQLPW
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh

echo "GRANT ALL ON dspam.* TO dspam@localhost IDENTIFIED BY 'p4ssw3rd'" | mysql -uroot -p$MYSQLPW
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh
wget ftp://ftp.qmailtoaster.com/pub/qmail/CentOS7/qmt/scripts/dspam/dspamdb.sql
if [ "$?" != "0" ]; then
   echo "Error downloading dspam db: ($?), exiting..."
   exit 1
fi
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh

# Change permissions on and place proper files necessary to run dspam daemon
chmod 777 /var/run/dspam
cp -p  /etc/dspam.conf /etc/dspam.conf.bak
wget ftp://ftp.qmailtoaster.com/pub/qmail/CentOS7/qmt/scripts/dspam/dspam.conf
if [ "$?" != "0" ]; then
   echo "Error downloading dspam conf: ($?), exiting..."
   exit 1
fi
chmod 744 /etc/dspam.conf

# Start/enable Dspam
$dson
$dsstart

# Implement dspam for all domains
domains=/home/vpopmail/domains
read -p "Implement dspam for domains? [Y/N]: " input
if [ "$input" = "Y" ] || [ "$input" = "y" ]; then
   for domain in `ls $domains`; do
      if [ -d $domains/$domain ]; then
         read -p "Add dspam functionality to $domain [Y]: " input1
         if [ "$input1" = "Y" ] || [ "$input1" = "y" ]; then
            mv $domains/$domain/.qmail-default $domains/$domain/.qmail-default.bak
            wget -O $domains/$domain/.qmail-default ftp://ftp.qmailtoaster.com/pub/qmail/CentOS7/qmt/scripts/dspam/.qmail-default
            echo "Domain: $domain ready..."
         else
            echo "Skipping $domain..."
         fi
      fi
   done
fi

exit 0
