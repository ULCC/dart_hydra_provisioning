#!/bin/bash

FITS="1.0.2" # testing 1.0.5
RUBY="2.3.3"
RAILS="5.0.0.1"
RAILS_MODE="development"

yes | sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel bzip2 autoconf automake libtool bison curl sqlite-devel
yes | sudo yum install -y java-1.8.0-openjdk.x86_64 wget unzip
# for fits "Error loading native library for MediaInfo please check that fits_home is properly set"
yes | sudo yum install libmediainfo libzen
# we'll need make for installing the pg gem
yes | sudo yum install -y make

# Install rbenv https://github.com/rbenv/rbenv
# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7
cd
if [ ! -d .rbenv ]
then
  echo 'Installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  # reload bash_profile
  source ~/.bash_profile
else
  echo '.rbenv is installed, moving on ...'
fi

echo 'Installing ruby '$RUBY
rbenv install $RUBY
rbenv global $RUBY

echo 'Installing LibreOffice, ImageMagick and Redis'
# LibreOffice
yes | sudo yum install –y libreoffice
# Install ImageMagick
yes | sudo yum install –y ImageMagick
# Install Redis - enable EPEL
# See https://support.rackspace.com/how-to/install-epel-and-additional-repositories-on-centos-and-red-hat/
yes | sudo yum install -y epel-release
# If the above doesn't work
if yum repolist | grep epel; then
  echo 'EPEL is enabled'
else
  echo 'Adding the EPEL Repo'
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo rpm -Uvh epel-release-latest-7*.rpm
fi
# Install Redis
yes | sudo yum install -y redis
# Start Redis
# For production, ensure starts at startup
# See http://sharadchhetri.com/2014/10/04/install-redis-server-centos-7-rhel-7/
# bind redis to 0.0.0.0 to allow external monitoring
sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf
echo 'Starting Redis'
sudo systemctl start redis.service
echo 'Enable Redis start at boot'
sudo systemctl enable redis.service

# Install Fits
# See https://github.com/projecthydra-labs/hyrax#characterization
cd
if [ ! -d fits-1.0.2 ]
then
  echo 'Downloading Fits '$FITS
  wget http://projects.iq.harvard.edu/files/fits/files/fits-$FITS.zip
  unzip fits-$FITS.zip
  rm fits-$FITS.zip
  chmod a+x fits-$FITS/fits.sh
else
  echo 'Fits is already here, moving on ... '
fi
# Install Rails
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

# Install nodejs
yes | sudo yum install -y nodejs

# Install postgress
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7

yes | sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
sudo postgresql-setup initdb

# change ident to md5 in /var/lib/pgsql/data/pg_hba.conf
sudo sed -i 's/ident/md5/' /var/lib/pgsql/data/pg_hba.conf

sudo systemctl start postgresql
sudo systemctl enable postgresql

# Add the user, create database and grant all privileges
sudo -u postgres bash -c "psql -c \"CREATE USER centos WITH PASSWORD 'centos';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE $RAILS_MODE;\""
sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE $RAILS_MODE TO centos;\""

# Clone and run hyku
cd /opt
if [ ! -d hyku ]
then
  echo 'Cloning hyku'
  sudo git clone https://github.com/ULCC/hyku
else
  echo 'hyku is already cloned, moving on ... '
fi
sudo chown -R centos:centos /opt/hyku
cd /opt/hyku
mv /home/centos/install_files/fedora.yml config/fedora.yml
mv /home/centos/install_files/solr.yml config/solr.yml
mv /home/centos/install_files/blacklight.yml config/blacklight.yml
mv /home/centos/install_files/settings.yml config/settings.yml
mv /home/centos/install_files/database.yml config/database.yml
mv /home/centos/install_files/production.yml config/settings/production.yml
mv /home/centos/install_files/production.rb config/environments/production.rb

echo 'Running bundler and db:migrate'
# error with rainbow needs gem update --system
gem update --system
bundle install
# setup secret key for devise; only used in production
SECRET=$(rails secret)
export SECRET_KEY_BASE=$SECRET
rake db:migrate RAILS_ENV=$RAILS_MODE

export SECRET_KEY_BASE=$SECRET
RAILS_ENV=$RAILS_MODE rake assets:precompile

export SECRET_KEY_BASE=$SECRET
DISABLE_REDIS_CLUSTER=true RAILS_ENV=$RAILS_MODE bundle exec sidekiq &

DISABLE_REDIS_CLUSTER=true nohup bundle exec rails server -e production -b0.0.0.0 &


# need to add admin_host in settings.yml (and check if these files have copied)