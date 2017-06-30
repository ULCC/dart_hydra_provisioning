#!/bin/bash

######################
# Install Shibboleth #
######################
# https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPLinuxRPMInstall
cp /tmp/install_files/shibboleth.repo /etc/yum.repos.d/
yes | yum install -y shibboleth.x86_64

#############
# Configure #
#############
cp /etc/shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xmlBAK
cp /tmp/install_files/sp2config.xml /etc/shibboleth/shibboleth2.xml

############################
# Start and enable at boot #
############################
/sbin/service shibd start
systemctl enable shibd

# Note: For Multiple shib idp http://shibboleth.net/pipermail/users/2016-May/029349.html
# Set within VirtualHost:
# ShibRequestSetting entityID http://site1.idp.com