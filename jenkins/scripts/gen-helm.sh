#!/usr/bin/env bash

mkdir helm
cd helm

source $DEVOPS_WORKSPACE/env

cp -rn $DEVOPS_WORKSPACE/jenkins/helm/* ./

envsubst < Chart.yaml > Chart.yaml.tmp
mv -f Chart.yaml.tmp Chart.yaml
cat Chart.yaml
envsubst < charts/app/values.yaml > charts/app/values.yaml.tmp
mv -f charts/app/values.yaml.tmp charts/app/values.yaml
cat charts/app/values.yaml
