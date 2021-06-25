#!/bin/bash

set -eu

apt update -y
apt upgrade -y

# SETUP LANGUAGE SETTING
apt install -y language-pack-ja-base language-pack-ja ibus-mozc
echo 'export LANG=ja_JP.UTF-8' >> ~/.bashrc
echo 'export LANGUAGE="ja_JP:ja"' >> ~/.bashrc

# SETUP TIMEZONE
timedatectl set-timezone Asia/Tokyo

# INSTALL packages
apt install -y zip unzip tree vim less make git nkf

# SETUP vim
mkdir -p ~/.vim/colors
cp .vimrc ~/
cp despacio.vim ~/.vim/colors


# INSTALL docker
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt install -y docker-ce docker-ce-cli containerd.io
# INSTALL docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

gpasswd -a ubuntu docker
systemctl restart docker
docker --version
docker-compose --version

# SETUP Remove Desktop
passwd ubuntu
gpasswd -a ubuntu sudo
apt -y install ubuntu-desktop
apt -y install xrdp
sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
systemctl restart xrdp
systemctl enable xrdp.service
systemctl enable xrdp-sesman.service
cat <<EOF > ~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF
cat <<EOF | sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla
[Netowrkmanager]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF
systemctl restart polkit

# INSTALL npm
apt install -y node-gyp nodejs-dev libssl1.0-dev nodejs npm
npm install -g n
n stable
apt --purge -y remove nodejs npm
exec $SHELL -l

# INSTALL aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
bash aws/install

# SETUP Miniconda
curl -OL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh


# CONFIGURE GIT
git config --global core.editor vim
echo 'CONFIGURE git user.name >> "git config --global user.name <USER NAME>"'
echo 'CONFIGURE git user.email >> "git config --global user.email <USER EMAIL>"'

echo 'run > bash Miniconda3-latest-Linux-x86_64.sh'

