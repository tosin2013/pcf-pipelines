#!/usr/bin/env bash
set -e

### Load env

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/common/utils/load-cf-env.sh
source $project_dir/common/utils/cf-helpers.sh

cf_authenticate_and_target
cf_target_org_and_space system chaos-loris
cf_create_service p-mysql 10mb chaos-loris-db


pushd binary
cat > manifest.yml <<EOS
---
applications:
- name: chaos-loris
  memory: 1G
  instances: 2
  path: chaos-loris.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git
  env:
    LORIS_CLOUDFOUNDRY_HOST: $API_DOMAIN
    LORIS_CLOUDFOUNDRY_PASSWORD: $pcf_admin_password
    LORIS_CLOUDFOUNDRY_SKIPSSLVALIDATION: true
    LORIS_CLOUDFOUNDRY_USERNAME: $pcf_admin_username
  services:
  - chaos-loris-db
EOS
cf push
exit_on_error "Error pushing app"
popd

