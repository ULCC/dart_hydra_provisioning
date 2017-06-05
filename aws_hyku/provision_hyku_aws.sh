#!/bin/bash

RAILS_MODE="production"
USER="centos"
BRANCH="master"
REPO="https://github.com/projecthydra-labs/hyku"

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

# TODO make it so these aren't necessary
#mv /home/centos/install_files/fedora.yml config/fedora.yml
#mv /home/centos/install_files/solr.yml config/solr.yml
#mv /home/centos/install_files/blacklight.yml config/blacklight.yml
#mv /home/centos/install_files/settings.yml config/settings.yml
#mv /home/centos/install_files/database.yml config/database.yml
#mv /home/centos/install_files/production.yml config/settings/production.yml
#mv /home/centos/install_files/production.rb config/environments/production.rb
#mv /home/centos/install_files/secrets.yml config/secrets.yml
mv /home/centos/install_files/rbenv-vars .rbenv-vars
rm -r /home/centos/install_files

echo 'turn off multitenancy'
sudo sed -i 's/true/false/' config/settings/production.yml
echo 'insert solr url into settings'
sudo sed -i 's/127.0.0.1/35.157.250.34/' config/settings.yml
sudo sed -i 's/host:/#host:/' config/database.yml
sudo sed -i 's/port:/#port:/' config/database.yml

echo 'Running setup'
RAILS_ENV=$RAILS_MODE bin/setup
# bundle install# bundle install
#rake db:create RAILS_ENV=$RAILS_MODE
#rake db:migrate RAILS_ENV=$RAILS_MODE
#rake hyrax:default_admin_set:create RAILS_ENV=$RAILS_MODE
#rake hyrax:workflow:load RAILS_ENV=$RAILS_MODE

# TODO only do this for production
RAILS_ENV=$RAILS_MODE rake assets:precompile

DISABLE_REDIS_CLUSTER=true bundle exec sidekiq -d -L log/sidekiq.log -e $RAILS_MODE
DISABLE_REDIS_CLUSTER=true bundle exec puma -e $RAILS_MODE -p 3000 --pidfile tmp/pids/puma.pid -d

echo 'Bye!'
exit 0
