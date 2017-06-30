#!/bin/bash

##################################
# Install Passenger (needs EPEL) #
##################################
# https://www.phusionpassenger.com/library/install/apache/install/oss/el7/

sudo yes | yum install -y epel-release yum-utils
sudo yum-config-manager --enable epel
sudo yum clean all && sudo yum update -y

# There are additional steps for RHEL here

########################
# Install dependencies #
########################
sudo yum install -y pygpgme curl

###############
# Date Output #
###############
# THIS IS NEEDED IF THE OUTPUT OF THE DATE IS WRONG
# if the output of date is wrong, please follow these instructions to install ntp
# date
# sudo yes | yum install -y ntp
# sudo chkconfig ntpd on
# sudo ntpdate pool.ntp.org
# sudo service ntpd start

######################################
# Add the Repo and install Passenger #
######################################
# Add our el7 YUM repository
sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

# Install Passenger + Apache module
sudo yes | yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yes | yum install -y mod_passenger

###################################################
# Replace existing hyku config with passenger one #
###################################################

cp /tmp/install_files/hyku_ssl_passenger.conf /etc/httpd/sites-available/hyku_ssl.conf

##################
# Restart Apache #
##################
service httpd restart

# Checks
# sudo /usr/bin/passenger-config validate-install
# sudo /usr/sbin/passenger-memory-stats


