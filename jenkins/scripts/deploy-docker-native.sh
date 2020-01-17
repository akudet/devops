#!/usr/bin/env bash

source $DEVOPS_WORKSPACE/env
source $DEVOPS_WORKSPACE/jenkins/config/env.$DEPLOY_ENV
export DEPLOY_NAME=${DEPLOY_NAME:-"$PROJECT_NAME-v$PROJECT_MAJOR_VERSION"}

docker login $DOCKER_SERVER

ech  "docker run --name $DEPLOY_NAME -d --restart=always -v run_env:/run/secrets/run_env:ro --network $DEPLOY_ENV -e SPRING_PROFILES_ACTIVE=$DEPLOY_ENV $DOCKER_IMAGE"

ssh -p $SSH_PORT $SSH_SERVER "docker rm -f $DEPLOY_NAME"
ssh -p $SSH_PORT $SSH_SERVER \
  "docker run --name $DEPLOY_NAME -d --restart=always -v run_env:/run/secrets/run_env:ro --network $DEPLOY_ENV -e SPRING_PROFILES_ACTIVE=$DEPLOY_ENV $DOCKER_IMAGE"
