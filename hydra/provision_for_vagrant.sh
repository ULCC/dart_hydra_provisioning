#!/bin/bash

cd
# TODO this will only work for hyrax_ulcc, make it work for either that or hyku
cd hyrax_ulcc

# Update the rake task so that we can bind to 0.0.0.0 (needed in vagrant to see the app running on localhost on the host machine)
# NB: fiddling with installed gems is a BAD thing to do but it's only needed for local vagrant boxes and development
echo 'Replacing the hydra-rake task so that we can bind to 0.0.0.0'
cd $(bundle show hydra-core)
cd lib/tasks
sudo rm hydra.rake
wget https://raw.githubusercontent.com/tdonohue/hydra-head/38b75222e2e6885c63a8847e9ce04635f35fa30e/hydra-core/lib/tasks/hydra.rake

echo 'Provisioning is complete, now follow these steps:'
echo '1. vagrant ssh'
echo '2. cd ~/hyrax_ulcc' or cd '~/hyku'
echo '3. rake hydra:server'
