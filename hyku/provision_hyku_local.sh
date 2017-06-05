#!/bin/bash

RAILS_MODE="development"
USER="vagrant"
BRANCH="master"
REPO="https://github.com/projecthydra-labs/hyku"

# Install postgres
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

gem install solr_wrapper
gem install fcrepo_wrapper

cp /vagrant/rbenv-vars .rbenv-vars

echo 'Now ssh into your machine and get everything running with the following ... '
echo 'solr_wrapper & fcrepo_wrapper &'
echo 'bin/setup'
echo 'DISABLE_REDIS_CLUSTER=true bundle exec sidekiq'
echo 'DISABLE_REDIS_CLUSTER=true bundle exec rails server -b 0.0.0.0'

echo 'Bye!'
exit 0
