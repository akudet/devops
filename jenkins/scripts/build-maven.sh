#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.name}' \
    --non-recursive \
    exec:exec)
export PROJECT_GROUP==$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.groupId}' \
    --non-recursive \
    exec:exec)
export PROJECT_NAME=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.artifactId}' \
    --non-recursive \
    exec:exec)
export PROJECT_VERSION=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.version}' \
    --non-recursive \
    exec:exec)
export PROJECT_MAJOR_VERSION=$(echo $PROJECT_VERSION | awk '{split($0,v,"."); print v[1]}')
export PROJECT_JAR="$PROJECT_NAME-$PROJECT_VERSION.jar"
export DOCKER_IMAGE=$DOCKER_SERVER/$ROOT_PROJECT_NAME/$PROJECT_NAME:$PROJECT_VERSION-$BUILD_NUMBER
export PROJECT_RELEASE='dev'
export PROJECT_NAMESPACE='dev'
export SERVER_PORT=8080
export APP_NAME=$PROJECT_NAME-v$PROJECT_MAJOR_VERSION

mvn package  -Dmaven.test.skip=true
mvn deploy  -Dmaven.test.skip=true

mkdir docker
cp "target/$PROJECT_JAR" docker/

envsubst < $WORKSPACE/dists/jenkins/scripts/env.txt > docker/env
envsubst < $WORKSPACE/dists/jenkins/scripts/template.txt > docker/Dockerfile
envsubst < $WORKSPACE/dists/jenkins/scripts/k8s-deploy.tpl.yaml > docker/k8s-deploy.yaml

cat docker/env
cat docker/Dockerfile
cat docker/k8s-deploy.yaml
