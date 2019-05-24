#!/usr/bin/env bash

source ./env

ssh vagrant@192.168.121.100 "kubectl set image deploy $ROOT_PROJECT_NAME $PROJECT_NAME=$DOCKER_IMAGE"