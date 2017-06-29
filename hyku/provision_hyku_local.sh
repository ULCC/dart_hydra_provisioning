#!/bin/bash

RAILS_MODE="production"
USER="vagrant"
BRANCH="kfpub_shib"
# REPO="https://github.com/projecthydra-labs/hyku"
REPO="https://github.com/ULCC/dart_hyku"
RAILS="5.0.3"

# TODO Handle this with users/groups properly
sudo chown -R $USER:$USER /usr/local/rbenv
# Make .rbenv available to the local user
if ! grep -q RBENV_ROOT "~/.bash_profile"; then
echo 'export RBENV_ROOT=/usr/local/rbenv' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
fi

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
# error with rainbow needs gem update --system
gem update --system
bundle install
mkdir tmp
mkdir tmp/pids # otherwise sidekiq won't start
sudo service sidekiq start # remember this is starting in production mode

gem install solr_wrapper
gem install fcrepo_wrapper
cp /tmp/install_files/rbenv-vars .rbenv-vars
rbenv vars
solr_wrapper clean
cp /install_files/fcrepo* /tmp/
cp /install_files/solr* /tmp/
solr_wrapper & fcrepo_wrapper &

echo 'Now ssh into your machine and get everything running with the following ... '
echo 'bin/setup'

echo 'Bye!'
exit 0
