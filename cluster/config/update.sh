#!/usr/bin/env bash

sudo cp /vagrant/config/resolvconf/resolv.conf.d/* /etc/resolvconf/resolv.conf.d/
sudo resolvconf -u

sudo mkdir -p /etc/docker/certs.d/harbor.dev.svc
sudo cp /vagrant/config/docker/certs.d/harbor.dev.svc/* /etc/docker/certs.d/harbor.dev.svc/
