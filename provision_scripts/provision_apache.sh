#!/bin/bash

yes | yum install -y httpd mod_ssl
systemctl enable httpd.service
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled

# https://wiki.centos.org/HowTos/Https
# USE THE EXISTING LOCALHOST CERT FOR NOW
# Generate private key
# openssl genrsa -out ca.key 2048
# Generate CSR
# openssl req -new -key ca.key -out ca.csr
# Generate Self Signed Key
# openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt

# Copy the files to the correct locations
# cp ca.crt /etc/pki/tls/certs/ca.crt
# cp ca.key /etc/pki/tls/private/ca.key
# cp ca.csr /etc/pki/tls/private/ca.csr

# sed -i 's/localhost.crt/ca.crt/' /etc/httpd/conf.d/ssl.conf
# sed -i 's/localhost.key/ca.key/' /etc/httpd/conf.d/ssl.conf

if ! grep -q sites-enabled "/etc/httpd/conf/httpd.conf"; then
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
fi

cp /tmp/install_files/hyku.conf /etc/httpd/sites-available/hyku.conf
cp /tmp/install_files/hyku_ssl.conf /etc/httpd/sites-available/hyku_ssl.conf
ln -s /etc/httpd/sites-available/hyku.conf /etc/httpd/sites-enabled/hyku.conf
ln -s /etc/httpd/sites-available/hyku_ssl.conf /etc/httpd/sites-enabled/hyku_ssl.conf

# TODO investigate this properly
# http://sysadminsjourney.com/content/2010/02/01/apache-modproxy-error-13permission-denied-error-rhel/
# /etc/sysconfig/selinux - set to permissive
# THIS WOULD REQUIRE A REBOOT
# sed -i 's/enforcing/permissive/' /etc/sysconfig/selinux
/usr/sbin/setsebool -P httpd_can_network_connect 1

service httpd restart


