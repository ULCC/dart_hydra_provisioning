#!/bin/bash

FITS="1.1.1"
RUBY="2.3.3"

echo 'Installing all the things'
yes | yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel bzip2 autoconf automake libtool bison curl sqlite-devel java-1.8.0-openjdk.x86_64 wget unzip
# Need make for installing the pg gem
yes | yum install -y make

echo 'Installing rbenv for all users'
# Install rbenv https://github.com/rbenv/rbenv
# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7
# https://blakewilliams.me/posts/system-wide-rbenv-install
cd /usr/local
if [ ! -d .rbenv ]
then
  echo 'Installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
  echo 'export RBENV_ROOT=/usr/local/rbenv' >> ~/.bash_profile
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
  #echo 'export PATH="/usr/local/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
  git clone https://github.com/rbenv/rbenv-vars.git /usr/local/rbenv/plugins/rbenv-vars
  echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
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
yes | yum install –y libreoffice
# Install ImageMagick
yes | yum install –y ImageMagick

# Install Redis - enable EPEL
# See https://support.rackspace.com/how-to/install-epel-and-additional-repositories-on-centos-and-red-hat/
yes | yum install -y epel-release
# If the above doesn't work
if yum repolist | grep epel; then
  echo 'EPEL is enabled'
else
  echo 'Adding the EPEL Repo'
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -Uvh epel-release-latest-7*.rpm
fi
# Install Redis
yes | yum install -y redis
# Start Redis
# See http://sharadchhetri.com/2014/10/04/install-redis-server-centos-7-rhel-7/
# bind redis to 0.0.0.0 to allow external monitoring
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf
echo 'Starting Redis'
systemctl start redis.service
echo 'Enable Redis start at boot'
systemctl enable redis.service

# Mediainfo is needed for Fits; it requires the EPEL repo
# otherwise fits "Error loading native library for MediaInfo please check that fits_home is properly set"
yes | yum install -y libmediainfo libzen mediainfo

# Install Fits
# See https://github.com/projecthydra-labs/hyrax#characterization
cd /opt
if [ ! -d fits-$FITS ]
then
  echo 'Downloading Fits '$FITS
  wget http://projects.iq.harvard.edu/files/fits/files/fits-$FITS.zip
  unzip fits-$FITS.zip
  rm fits-$FITS.zip
  chmod a+x fits-$FITS/fits.sh
  ln -s /opt/fits-$FITS/fits.sh /usr/bin/fits.sh
else
  echo 'Fits is already here, moving on ... '
fi

# Install nodejs
yes | yum install -y nodejs