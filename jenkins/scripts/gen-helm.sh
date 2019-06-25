#!/usr/bin/env bash

cp -rn $WORKSPACE/dists/jenkins/helm/* ./

envsubst < Chart.yaml > Chart.yaml.tmp
mv -f Chart.yaml.tmp Chart.yaml
envsubst < charts/app/values.yaml > charts/app/values.yaml.tmp
mv -f charts/app/values.yaml.tmp charts/app/values.yaml
