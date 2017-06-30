#!/bin/bash

USER="centos"
RAILS="5.0.3"
RAILS_MODE="production"
REPO=https://github.com/ULCC/dart_hyku
BRANCH="kfpub_shib"
SOLR_URL="35.157.250.34"

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
fi
source ~/.bash_profile

#################
# Install Rails #
#################
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
# TODO change the user/password, consider what privileges the user needs
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

################################
# Setup Hyku with local config #
################################
cp /tmp/install_files/.rbenv-vars .rbenv-vars

echo 'turn off multitenancy'
sudo sed -i 's/true/false/' config/settings/production.yml
echo 'insert solr url into settings'
sudo sed -i 's/127.0.0.1/$SOLR_URL/' config/settings.yml
# Comment out the host and port in the database config
sudo sed -i 's/host:/#host:/' config/database.yml
sudo sed -i 's/port:/#port:/' config/database.yml

#############
# Run setup #
#############
RAILS_ENV=$RAILS_MODE rake db:migrate
RAILS_ENV=$RAILS_MODE bin/setup

####################################
# Precompile assets for production #
####################################
RAILS_ENV=$RAILS_MODE rake assets:precompile

#################
# Start sidekiq #
#################
mkdir tmp
mkdir tmp/pids # otherwise sidekiq won't start
sudo service sidekiq start # remember this is starting in production mode
sudo service httpd restart

# Start rails with something like this if not using passenger
# DISABLE_REDIS_CLUSTER=true bundle exec puma -e $RAILS_MODE -p 3000 --pidfile tmp/pids/puma.pid -d

echo 'Bye!'
exit 0
