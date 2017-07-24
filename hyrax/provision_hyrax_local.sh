#!/bin/bash

USER="vagrant"
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

#######################################################
# Change ownership fits to the local user #
#######################################################
sudo chown -R $USER:$USER /opt/fits*

#################
# Install Rails #
#################
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

  # Quick and dirty setup for Hyrax
  # TODO set rails version properly

  cd /opt
  if [ ! -d hyrax ]
  then
    sudo mkdir hyrax
    sudo chown -R $USER:$USER hyrax
    echo 'Create hyrax'
    rails _5.0.3_ new hyrax -m https://raw.githubusercontent.com/samvera/hyrax/master/template.rb
    cd hyrax
    rake db:migrate
    rails generate hyrax:work GenericWork
  else
    echo 'Hyrax exists, moving on ... '
  fi

echo 'Now ssh into the machine and get everything running with the following ... '
echo '/opt/hyrax'
echo 'solr_wrapper & fcrepo_wrapper &'
echo 'bin/rails hyrax:default_admin_set:create'
echo 'rails s -b 0.0.0.0'
echo 'to make yourself an admin create a user in the app add the new user to config/role_map.yml as admin:'

echo 'Bye!'
exit 0
