#!/bin/bash

USER="centos"
RAILS="5.0.3"
RAILS_MODE="production"
REPO=https://github.com/ULCC/dart_hyku
BRANCH="kfpub_shib"
SOLR_URL="35.157.250.34"

# TODO Handle this with users/groups properly
# For now, change ownership of rbenv to the local user
sudo chown -R $USER:$USER /usr/local/rbenv

# Add .rbenv available to the local user bash_profile
if ! grep -q RBENV_ROOT "~/.bash_profile"; then
echo 'export RBENV_ROOT=/usr/local/rbenv' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
fi
source ~/.bash_profile

# Install Rails
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

# Add the user, create database and grant all privileges
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"ALTER USER $USER CREATEDB;\""

# Clone hyku
cd /opt
if [ ! -d hyku ]
then
echo 'Cloning hyku'
sudo git clone $REPO hyku
else
echo 'hyku is already cloned, moving on ... '
fi

sudo chown -R $USER:$USER /opt/hyku
sudo chown -R $USER:$USER /opt/fits*
cd /opt/hyku
git checkout $BRANCH

echo 'Running bundler'
# in the past, an error with rainbow needs gem update --system
gem update --system
bundle install

cp /tmp/install_files/.rbenv-vars .rbenv-vars

echo 'turn off multitenancy'
sudo sed -i 's/true/false/' config/settings/production.yml
echo 'insert solr url into settings'
sudo sed -i 's/127.0.0.1/$SOLR_URL/' config/settings.yml
# Comment out the host and port in the database config
sudo sed -i 's/host:/#host:/' config/database.yml
sudo sed -i 's/port:/#port:/' config/database.yml

echo 'Running setup'
RAILS_ENV=$RAILS_MODE rake db:migrate
RAILS_ENV=$RAILS_MODE bin/setup

RAILS_ENV=$RAILS_MODE rake assets:precompile

mkdir tmp
mkdir tmp/pids # otherwise sidekiq won't start
sudo service sidekiq start
sudo service httpd restart

# DISABLE_REDIS_CLUSTER=true bundle exec puma -e $RAILS_MODE -p 3000 --pidfile tmp/pids/puma.pid -d

echo 'Bye!'
exit 0
