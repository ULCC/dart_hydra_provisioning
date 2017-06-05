#!/bin/bash

FITS="1.0.2"
RUBY="2.3.3"
RAILS="5.0.3"
USER=vagrant

echo 'Installing all the things'
yes | sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel bzip2 autoconf automake libtool bison curl sqlite-devel java-1.8.0-openjdk.x86_64 wget unzip
# for fits "Error loading native library for MediaInfo please check that fits_home is properly set"
yes | sudo yum install libmediainfo libzen
# Need make for installing the pg gem
yes | sudo yum install -y make

echo 'Installing rbenv'
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
  git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
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
cd /opt
if [ ! -d fits-1.0.2 ]
then
  echo 'Downloading Fits '$FITS
  sudo wget http://projects.iq.harvard.edu/files/fits/files/fits-$FITS.zip
  sudo unzip fits-$FITS.zip
  sudo rm fits-$FITS.zip
  sudo chmod a+x fits-$FITS/fits.sh
  sudo ln -s /opt/fits-1.0.2/fits.sh /usr/bin/fits.sh
else
  echo 'Fits is already here, moving on ... '
fi
# Install Rails
echo 'Installing rails '$RAILS
gem install rails -v $RAILS

# Install nodejs
yes | sudo yum install -y nodejs