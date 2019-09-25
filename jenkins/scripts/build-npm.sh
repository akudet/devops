#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(node -p "require('./package.json').name" )
export PROJECT_NAME=$(node -p "require('./package.json').name")
export PROJECT_VERSION=$(node -p "require('./package.json').version")
export PROJECT_MAJOR_VERSION=$(echo $PROJECT_VERSION | awk '{split($0,v,"."); print v[1]}')
export DOCKER_IMAGE=$DOCKER_SERVER/$ROOT_PROJECT_NAME/$PROJECT_NAME:$PROJECT_VERSION-$BUILD_ID-$DEPLOY_ENV

envsubst < $DEVOPS_WORKSPACE/jenkins/scripts/env > $DEVOPS_WORKSPACE/env
cat $DEVOPS_WORKSPACE/env

[[ -d node_modules ]] || npm install

# for vue 2
NODE_ENV=$DEPLOY_ENV
npm run build -- --mode=$DEPLOY_ENV

mkdir docker
mkdir docker/app
cp -r dist/* docker/app/
envsubst < $DEVOPS_WORKSPACE/jenkins/docker/nodejs/Dockerfile > docker/Dockerfile
cp -rn $DEVOPS_WORKSPACE/jenkins/docker/nodejs/app/* docker/app/
