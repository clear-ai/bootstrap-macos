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
  chmod -R g+w /usr/local
  chmod -R g+w /Library/Caches/Homebrew
  brew update
else
  echo "[INFO] looks like brew works!"
fi
brew upgrade

echo "[INFO] install ansible"
brew install ansible

echo "[INFO] Execute ansible playbook"
cd ansible
ansible-playbook -v playbooks/playbook.yaml
