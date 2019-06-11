#!/usr/bin/env bash

source ./env

scp ./k8s-deploy.yaml $DEPLOY_SERVER:~
ssh $DEPLOY_SERVER "kubectl apply -f ~/k8s-deploy.yaml"
