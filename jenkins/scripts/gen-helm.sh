#!/usr/bin/env bash

source $DO_WORKSPACE/env

cp -rn $DO_WORKSPACE/jenkins/helm/* ./

envsubst < Chart.yaml > Chart.yaml.tmp
mv -f Chart.yaml.tmp Chart.yaml
cat Chart.yaml
envsubst < charts/app/values.yaml > charts/app/values.yaml.tmp
mv -f charts/app/values.yaml.tmp charts/app/values.yaml
cat charts/app/values.yaml
