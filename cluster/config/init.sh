#!/usr/bin/env bash

sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock

sudo cp /home/vagrant/config/apt/sources.list /etc/apt/sources.list

sudo apt update

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo cp /home/vagrant/config/apt/sources.list.d/docker.list /etc/apt/sources.list.d/

curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
sudo cp /home/vagrant/config/apt/sources.list.d/kubernetes.list /etc/apt/sources.list.d/

sudo apt update
sudo apt install -y docker-ce

sudo groupadd docker
sudo usermod -aG docker vagrant

sudo apt install -y kubeadm

