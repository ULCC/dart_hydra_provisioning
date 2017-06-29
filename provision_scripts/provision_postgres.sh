#!/bin/bash

# Install postgres
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7

yes | yum install -y postgresql-server postgresql-contrib postgresql-devel
postgresql-setup initdb

# change ident to md5 in /var/lib/pgsql/data/pg_hba.conf
sed -i 's/ident/md5/' /var/lib/pgsql/data/pg_hba.conf

systemctl start postgresql
systemctl enable postgresql