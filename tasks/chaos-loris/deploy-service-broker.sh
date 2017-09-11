#!/usr/bin/env bash

set -e

source ./pcf-pipelines/functions/export_cf_credentials.sh
cf api https://api.${SYSTEM_DOMAIN} --skip-ssl-validation
cf auth $pcf_admin_username $pcf_admin_password
cf target -o $ORG -s $SPACE

cf_create_service p-mysql 10mb chaos-loris-broker-db

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
    CHAOS_LORIS_HOST: https://chaos-loris.app.$APPS_DOMAIN
  services:
  - chaos-loris-broker-db
EOS

echo "##############################"
cf push
echo "##############################"
