#!/bin/bash

PHANTOM="phantomjs-2.1.1-linux-x86_64"

#####################################################
# Install phantomjs (only needed for running tests) #
#####################################################

yes | sudo yum install -y fontconfig
if [ ! -d /opt/phantomjs ]
then
    cd ~
    wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM.tar.bz2
    tar xvf $PHANTOM.tar.bz2
    sudo mv $PHANTOM /opt/phantomjs
    sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs
else
  echo 'phantomjs is installed, moving on ... '
fi