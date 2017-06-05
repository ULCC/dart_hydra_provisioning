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
