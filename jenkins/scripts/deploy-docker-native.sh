#!/usr/bin/env bash

source $DEVOPS_WORKSPACE/env

if [ -f "jenkins/env" ]; then
  . jenkins/env
fi

if [ -f "jenkins/env.$DEPLOY_ENV" ]; then
  . jenkins/env.$DEPLOY_ENV
fi

export DEPLOY_NAME=${DEPLOY_NAME:-"$PROJECT_NAME"}

INGRESS_PATH=${INGRESS_PATH:-"/$PROJECT_NAME"}

printenv

curl --insecure -X PUT "$GATEWAY_URL/build/updateZuulConfig" \
  -d "project_name=$PROJECT_NAME" \
  -d "project_path=$INGRESS_PATH/**" \
  -d "project_url=http://$PROJECT_NAME/"

DOCKER_RUN="docker run --name $DEPLOY_NAME -d --restart=always $DOCKER_OPTIONS -v run_env:/run/secrets/run_env:ro --network $DEPLOY_ENV -e SPRING_PROFILES_ACTIVE=$DEPLOY_ENV $DOCKER_IMAGE"

echo $DOCKER_RUN

ssh -p $SSH_PORT $SSH_SERVER "docker login $DOCKER_SERVER"
ssh -p $SSH_PORT $SSH_SERVER "docker rm -f $DEPLOY_NAME"
ssh -p $SSH_PORT $SSH_SERVER "$DOCKER_RUN"
ssh -p $SSH_PORT $SSH_SERVER "docker image prune -f -a --filter=label=app=$PROJECT_NAME"
