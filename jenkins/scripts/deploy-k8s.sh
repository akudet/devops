#!/usr/bin/env bash

source ./env

scp ./k8s-deploy.yaml vagrant@192.168.121.100:~
ssh vagrant@192.168.121.100 "kubectl apply -f ~/k8s-deploy.yaml"
