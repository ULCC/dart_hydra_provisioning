#!/bin/bash

####################################
# Add sidekiq as a systemd service #
####################################
cp /tmp/install_files/sidekiq.service /etc/systemd/system/

######################
# Change permissions #
######################
chmod 664 /etc/systemd/system/sidekiq.service

####################
# Reload systemctl #
####################
systemctl daemon-reload

#####################
# Enable at startup #
#####################
systemctl enable sidekiq.service
# Don't run it yet as the /opt/hyku directory doesn't yet exist
