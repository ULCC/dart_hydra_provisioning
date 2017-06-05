#!/bin/bash

# TODO set rails version properly

# Use vagrant directory for hyrax to allow in-host tinkering (and to avoid faff of permissions in opt)
cd /vagrant
if [ ! -d hyrax ]
then
  echo 'Create hyrax'
  rails _5.0.3_ new hyrax
  cd /vagrant/hyrax
  # TODO insert hyrax directly rather than copy file
  cp /vagrant/Gemfile /vagrant/hyrax/Gemfile
  bundle install
  rails generate hyrax:install -f
  rake db:create
  rails generate roles
  rake db:migrate
  rails generate hyrax:work GenericWork
else
  echo 'Hyrax exists, moving on ... '
fi