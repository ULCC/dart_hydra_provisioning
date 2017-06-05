#!/bin/bash

cd /vagrant/hyrax
cp /vagrant/rbenv-vars .rbenv-vars

echo 'Now ssh into your machine and get everything running with the following ... '
# echo 'rake hydra:server'
echo 'solr_wrapper & fcrepo_wrapper &'
echo 'rake hyrax:default_admin_set:create'
echo 'rails s -b 0.0.0.0'
echo 'create an account'
echo 'add the new user to config/role_map.yml as an admin'

echo 'Bye!'
exit 0
