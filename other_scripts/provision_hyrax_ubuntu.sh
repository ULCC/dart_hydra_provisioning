#!/bin/bash

FITS="1.0.2"
RUBY="2.3.3"
RAILS="5.0.0.1"
INSTALLPATH="/mnt/hgfs/sites"

sudo apt-get update
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get install -y git unzip wget openjdk-8* sqlite3 libsqlite3-dev
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04
# sudo apt-get install postgresql postgresql-contrib

# Install rbenv https://github.com/rbenv/rbenv
# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
cd ~
if [ ! -d .rbenv ]
then
  echo 'Installing .rbenv'
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  # reload bash_profile
  source ~/.bashrc
else
  echo '.rbenv is installed, moving on ...'
fi

echo 'Installing ruby '$RUBY
rbenv install $RUBY 
rbenv global $RUBY

echo 'Install nodejs'
# Nodejs
sudo apt-get install -y nodejs

echo 'Installing LibreOffice, ImageMagick and Redis'
# LibreOffice
sudo apt-get install -y libreoffice
# Install ImageMagick
sudo apt-get install -y imagemagick
# Install Redis
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
sudo apt-get install -r build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
sudo make install
sudo mkdir /etc/redis
sudo cp /tmp/redis-stable/redis.conf /etc/redis #edit this
sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

# Start Redis
sudo systemctl start redis
# sudo systemctl status redis
echo 'Starting Redis'
echo 'Enable Redis start at boot'
sudo systemctl enable redis
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
# Clone and run hyrax_ulcc
cd $INSTALLPATH
mkdir tmp 
if [ ! -d hyrax_ulcc ]
then
  echo 'Cloning hyrax_ulcc'
  git clone https://github.com/ULCC/hyrax_ulcc.git 
  cd hyrax_ulcc
  cp /sites/hyrax_ulcc/provision/install_files/env_rename_me .env
else
  echo 'hyrax_ulcc is already cloned, moving on ... '
fi
cd hyrax_ulcc
echo 'Running bundler and db:migrate'
bundle install 
rake db:migrate 
# Update the rake task so that we can bind to 0.0.0.0 (needed in vagrant to see the app running on localhost on the host machine)
# NB: fiddling with installed gems is a BAD thing to do but it's only needed for local vagrant boxes and development
echo 'Replacing the hydra-rake task so that we can bind to 0.0.0.0'
cd $(bundle show hydra-core)
cd lib/tasks
sudo rm hydra.rake
wget https://raw.githubusercontent.com/tdonohue/hydra-head/38b75222e2e6885c63a8847e9ce04635f35fa30e/hydra-core/lib/tasks/hydra.rake
echo 'Provisioning is complete, now follow these steps:'
echo '1. vagrant ssh'
echo '2. cd ~/hyrax_ulcc'
echo '3. rake hydra:server'
