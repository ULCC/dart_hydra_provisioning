#!/bin/bash

RAILS_MODE="production"
SOLR="35.157.250.34"

cd /opt/hyku

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
sudo sed -i 's/true/false/' /config/settings/production.yml
echo 'insert solr url into settings'
sudo sed -i 's/127.0.0.1/$SOLR/' /config/settings.yml

echo 'Running bundler and db:migrate'
# old error with rainbow needed this; no harm in doing it now
gem update --system
RAILS_ENV=$RAILS_MODE bin/setup
# bundle install# bundle install
#rake db:create RAILS_ENV=$RAILS_MODE
#rake db:migrate RAILS_ENV=$RAILS_MODE
#rake hyrax:default_admin_set:create RAILS_ENV=$RAILS_MODE
#rake hyrax:workflow:load RAILS_ENV=$RAILS_MODE

# TODO only do this for production
if [ "$RAILS_MODE" = "production" ]
then
    RAILS_ENV=$RAILS_MODE rake assets:precompile
else
    echo '$RAILS_MODE mode, no need to precompile'
fi

DISABLE_REDIS_CLUSTER=true bundle exec sidekiq -d -L log/sidekiq.log -e $RAILS_MODE
DISABLE_REDIS_CLUSTER=true bundle exec puma -e $RAILS_MODE -p 3000 --pidfile tmp/pids/puma.pid -d

echo 'Bye!'
exit 0
