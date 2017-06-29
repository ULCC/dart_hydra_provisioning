#!/bin/bash

# Copy the systemd service file into place
cp /tmp/install_files/sidekiq.service /etc/systemd/system/
# Change permissions
chmod 664 /etc/systemd/system/sidekiq.service
# Reload systemctl to make the new systemd script usable
systemctl daemon-reload
# Enable at startup
systemctl enable sidekiq.service
# Don't run it yet as the /opt/hyku directory doesn't yet exist
