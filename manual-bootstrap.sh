#!/usr/bin/env bash

set -e

ADMIN_USER="admin"
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin"

echo "[INFO] checking user:$ADMIN_USER can sudo without password"
sudo -H -u $ADMIN_USER bash -c 'sudo echo'
if [ $? -ne 0 ]; then
  echo "[INFO] allow user:$ADMIN_USER to sudo without password"
  echo "$ADMIN_USER ALL = (ALL) NOPASSWD:ALL" >> /etc/sudoers
else
  echo "[INFO] user:$ADMIN_USER should be able to sudo without password!"
fi

echo "[INFO] Clone bootstrap repo"
sudo -H -n -u $ADMIN_USER bash -c 'cd ~ && rm -rf bootstrap-macos; git clone https://github.com/clear-ai/bootstrap-macos.git'

sudo -H -n -u $ADMIN_USER bash -c 'cd ~/bootstrap-macos && ./bootstrap.sh'
