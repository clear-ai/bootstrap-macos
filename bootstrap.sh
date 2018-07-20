#!/bin/sh

ADMIN_USER="admin"
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin"

echo "[INFO] checking if brew is installed"
brew --version
if [ $? -ne 0 ]; then
  echo "[INFO] installing brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
else
  echo "[INFO] brew is installed!"
fi

echo "[INFO] checking if zsh is installed"
zsh --version
if [ $? -ne 0 ]; then
  echo "[INFO] installing zsh"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "[INFO] zsh is installed!"
fi

echo "[INFO] update brew"
brew update
if [ $? -ne 0 ]; then
  echo "[INFO] fix brew"
  # allow admins to manage homebrew's local install directory
  sudo chgrp -R $ADMIN_USER /usr/local
  sudo chmod -R g+w /usr/local

  # allow admins to homebrew's local cache of formulae and source files
  sudo chgrp -R $ADMIN_USER /Library/Caches/Homebrew
  sudo chmod -R g+w /Library/Caches/Homebrew

  # if you are using cask then allow admins to manager cask install too
  sudo chgrp -R $ADMIN_USER /opt/homebrew-cask
  sudo chmod -R g+w /opt/homebrew-cask

  brew update
else
  echo "[INFO] looks like brew works!"
fi
brew upgrade

echo "[INFO] install ansible"
brew install ansible

echo "[INFO] Execute ansible playbook"
cd ansible
ansible-playbook playbooks/playbook.yaml
