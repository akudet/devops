#!/usr/bin/env bash

docker service create --name jenkins \
  --publish 8080:8080 --publish 50000:50000 \
  --mount src=jenkins_home,dst=/var/jenkins_home \
  jenkins/jenkins:lts

docker run \
  --name jenkins \
  -d \
  -u root \
  -p 5080:8080 \
  --restart=always \
  -v ~/.ssh:/root/.ssh \
  -v ~/.docker:/root/.docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/jenkins_blueocean:/var/jenkins_home \
  jenkinsci/blueocean