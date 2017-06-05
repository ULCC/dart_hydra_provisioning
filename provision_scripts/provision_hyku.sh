#!/bin/bash

RAILS_MODE="development"
REPO="https://github.com/projecthydra-labs/hyku"
BRANCH="master"
USER=vagrant

# Install postgress
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7

yes | sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
sudo postgresql-setup initdb

# change ident to md5 in /var/lib/pgsql/data/pg_hba.conf
sudo sed -i 's/ident/md5/' /var/lib/pgsql/data/pg_hba.conf

sudo systemctl start postgresql
sudo systemctl enable postgresql

# Add the user, create database and grant all privileges
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"ALTER USER $USER CREATEDB;\""

# Clone hyku
cd /opt
if [ ! -d hyku ]
then
  echo 'Cloning hyku'
  sudo git clone $REPO
else
  echo 'hyku is already cloned, moving on ... '
fi
sudo chown -R $USER:$USER /opt/hyku
cd /opt/hyku
git checkout $BRANCH

echo 'Running bundler'
# error with rainbow needs gem update --system
gem update --system
bundle install