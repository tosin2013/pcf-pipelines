#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh

erb < ../pcf-pipelines/bosh-manifests/$DEPLOYMENT_NAME.yml.erb > manifest.yml

bosh -d $DEPLOYMENT_NAME deploy manifest.yml
