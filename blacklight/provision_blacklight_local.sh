#!/bin/bash

# Use vagrant directory for blacklight to allow in-host tinkering (and to avoid faff of permissions in opt)
cd /vagrant
if [ ! -d blacklight ]
then
  echo 'Create blacklight'
  rails _5.0.3_ new blacklight
  cd /vagrant/blacklight
  # TODO insert blacklight directly rather than copy file
  cp /vagrant/Gemfile /vagrant/blacklight/Gemfile
  bundle install
  rails generate blacklight:install
  rake db:create
  rake db:migrate
  gem install solr_wrapper
else
  echo 'blacklight exists, moving on ... '
fi

echo 'Now ssh into your machine and get everything running with the following ... '
echo 'solr_wrapper &'
echo 'rails s -b 0.0.0.0'