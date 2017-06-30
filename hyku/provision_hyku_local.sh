#!/bin/bash

RAILS_MODE="production"
USER="vagrant"
BRANCH="kfpub_shib"
# REPO="https://github.com/projecthydra-labs/hyku"
REPO="https://github.com/ULCC/dart_hyku"
RAILS="5.0.3"

####################################################################
# Setup rbenv for the local user and change ownership to this user #
####################################################################
# TODO Handle this with users/groups properly
sudo chown -R $USER:$USER /usr/local/rbenv

if ! grep -q RBENV_ROOT "~/.bash_profile"; then
echo 'export RBENV_ROOT=/usr/local/rbenv' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
fi

#################
# Install Rails #
#################
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
# TODO change the password, consider what privileges the user needs
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"ALTER USER $USER CREATEDB;\""

##############
# Clone Hyku #
##############
cd /opt
if [ ! -d hyku ]
then
  echo 'Cloning hyku'
  sudo git clone $REPO hyku
else
  echo 'hyku is already cloned, moving on ... '
fi

#######################################################
# Change ownership of hyku and fits to the local user #
#######################################################
sudo chown -R $USER:$USER /opt/hyku
sudo chown -R $USER:$USER /opt/fits*
cd /opt/hyku
###################
# Checkout branch #
###################
git checkout $BRANCH

###############
# Run bundler #
###############
# error with rainbow needs gem update --system
gem update --system
bundle install
#################
# Start sidekiq #
#################
mkdir tmp
mkdir tmp/pids # otherwise sidekiq won't start
sudo service sidekiq start # remember this is starting in production mode

##############################
# Install and start wrappers #
##############################
gem install solr_wrapper
gem install fcrepo_wrapper
cp /tmp/install_files/rbenv-vars .rbenv-vars
rbenv vars
solr_wrapper clean
cp /install_files/fcrepo* /tmp/ # speed things up with local copies
cp /install_files/solr* /tmp/ # speed things up with local copies
solr_wrapper & fcrepo_wrapper &

echo 'Now ssh into your machine and get everything running with the following ... '
echo 'bin/setup'

echo 'Bye!'
exit 0
