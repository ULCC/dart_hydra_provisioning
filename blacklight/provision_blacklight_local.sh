#!/bin/bash

RAILS_MODE="development"
REPO="https://github.com/projecthydra-labs/hyku"
BRANCH="master"
USER=vagrant
RAILS="5.0.3"

# Use vagrant directory for hyrax to allow in-host tinkering (and to avoid faff of permissions in opt)
cd /vagrant
if [ ! -d hyrax ]
then
  echo 'Create hyrax'
  rails _5.0.3_ new hyrax
  cd /vagrant/hyrax
  # TODO insert hyrax and hydra-role-management directly rather than copy file
  cp /vagrant/Gemfile /vagrant/hyrax/Gemfile
  bundle install
  rails generate hyrax:install -f
  rake db:create
  rake db:migrate
  rails generate roles
  rake db:migrate
else
  echo 'Hyrax exists, moving on ... '
fi

echo 'Now ssh into your machine and get everything running with the following ... '
# echo 'export HOST="0.0.0.0" & rake hydra:server'
echo 'solr_wrapper & fcrepo_wrapper &'
echo 'bin/rails hyrax:default_admin_set:create & bin/rails hyrax:workflow:load'
echo 'rails s -b 0.0.0.0'