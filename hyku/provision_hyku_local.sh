#!/bin/bash

cd /opt/hyku

gem install solr_wrapper
gem install fcrepo_wrapper

cp /vagrant/rbenv-vars .rbenv-vars

echo 'Now ssh into your machine and get everything running with the following ... '
echo 'solr_wrapper & fcrepo_wrapper &'
echo 'bin/setup'
echo 'DISABLE_REDIS_CLUSTER=true bundle exec sidekiq'
echo 'DISABLE_REDIS_CLUSTER=true bundle exec rails server -b 0.0.0.0'

echo 'Bye!'
exit 0
