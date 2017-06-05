#!/bin/bash

RAILS_MODE="production"

# TODO make it so these aren't necessary
mv /home/centos/install_files/fedora.yml config/fedora.yml
mv /home/centos/install_files/solr.yml config/solr.yml
mv /home/centos/install_files/blacklight.yml config/blacklight.yml
mv /home/centos/install_files/settings.yml config/settings.yml
mv /home/centos/install_files/database.yml config/database.yml
mv /home/centos/install_files/production.yml config/settings/production.yml
mv /home/centos/install_files/production.rb config/environments/production.rb
mv /home/centos/install_files/secrets.yml config/secrets.yml
rm -r /home/centos/install_files

echo 'Running bundler and db:migrate'
# error with rainbow needs gem update --system
gem update --system
# these are all covered by bin/setup now
bundle install
rake db:create RAILS_ENV=$RAILS_MODE
rake db:migrate RAILS_ENV=$RAILS_MODE
rake hyrax:default_admin_set:create RAILS_ENV=$RAILS_MODE
rake hyrax:workflow:load RAILS_ENV=$RAILS_MODE

# TODO only do this for production
RAILS_ENV=$RAILS_MODE rake assets:precompile

DISABLE_REDIS_CLUSTER=true bundle exec sidekiq -d -L log/sidekiq.log -e $RAILS_MODE
DISABLE_REDIS_CLUSTER=true bundle exec puma -e $RAILS_MODE -p 3000 --pidfile tmp/pids/puma.pid -d

echo 'Bye!'
exit 0
