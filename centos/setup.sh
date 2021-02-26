#!/bin/bash

set -eu

yum update -y
yum upgrade -y

# INSTALL packages
yum install -y zip unzip tree vim less make git nkf

# SETUP vim
mkdir -p ~/.vim/colors
cp .vimrc ~/
cp despacio.vim ~/.vim/colors


# INSTALL docker
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
# INSTALL docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

gpasswd -a jaist docker
systemctl restart docker
# docker --version
# docker-compose --version

# INSTALL xrdp
yum install -y epel-release
sed -i -e 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
yum group install -y "GNOME Desktop"
yum install -y --enablerepo=epel xrdp
systemctl start xrdp.service
systemctl enable xrdp.service
firewall-cmd --permanent --add-port=3389/tcp
firewall-cmd --reload
sed -i -e 's/enabled=0/enabled=1/g' /etc/yum.repos.d/epel.repo

# INSTALL npm
yum install -y nodejs npm
npm install -g n
n stable
yum remove -y nodejs npm
exec $SHELL -l

# INSTALL aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
bash aws/install

# SETUP Anaconda
yum install -y libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
curl -OL https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh

# CONFIGURE GIT
git config --global core.editor vim
echo 'CONFIGURE git user.name >> "git config --global user.name <USER NAME>"'
echo 'CONFIGURE git user.email >> "git config --global user.email <USER EMAIL>"'

# Anaconda Install 
echo To Install Anaconda, Run:
echo '> bash Anaconda3-2020.07-Linux-x86_64.sh'

