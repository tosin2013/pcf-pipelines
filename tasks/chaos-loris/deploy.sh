#!/usr/bin/env bash

### Load env

set -e

source ./pcf-pipelines/functions/export_cf_credentials.sh
source ./pcf-pipelines/functions/cf-helpers.sh
cf_authenticate_and_target
cf_target_org_and_space system chaos-loris
cf target -o $ORG -s $SPACE

cf_ create-service p-mysql 100mb chaos-loris-broker-db

cd binary
cat > manifest.yml <<EOS
---
applications:
- name: chaos-loris-broker
  memory: 512M
  instances: 2
  buildpack: https://github.com/ryandotsmith/null-buildpack
  path: .
  command: ./cf-chaos-loris-broker -c plans.yml
  env:
    CHAOS_LORIS_HOST: https://chaos-loris.$APPS_DOMAIN
  services:
  - chaos-loris-broker-db
EOS

echo "##############################"
cf push
exit_on_error "Error pushing app"
echo "##############################"
