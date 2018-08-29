#!/usr/bin/env bash

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

echo "[INFO] checking if brew is installed"
sudo -H -u $ADMIN_USER bash -c 'brew --version'
if [ $? -ne 0 ]; then
  echo "[INFO] installing brew"
  sudo -H -u $ADMIN_USER bash -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null'
  echo "[INFO] fix brew"
  # allow admins to manage homebrew's local install directory
  chgrp -R admin /usr/local/*
  chmod -R g+w /usr/local/*

  # allow admins to homebrew's local cache of formulae and source files
  chgrp -R admin /Library/Caches/Homebrew
  chmod -R g+w /Library/Caches/Homebrew

  # if you are using cask then allow admins to manager cask install too
  chgrp -R admin /opt/homebrew-cask
  chmod -R g+w /opt/homebrew-cask
else
  echo "[INFO] brew is installed!"
fi

echo "[INFO] Clone bootstrap repo"

chown -R $ADMIN_USER:staff ./

sudo -H -u $ADMIN_USER bash -c 'git clone https://github.com/clear-ai/bootstrap-macos.git'

cd bootstrap-macos

sudo -H -n -u $ADMIN_USER bash -c './bootstrap.sh'
