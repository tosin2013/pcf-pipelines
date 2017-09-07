#!/bin/bash -e

source ./pcf-pipelines/functions/export_cf_credentials.sh

cd app
erb < ../pcf-pipelines/app-manifests/$APP_NAME.yml.erb > manifest.yml
cf api https://api.${SYSTEM_DOMAIN} --skip-ssl-validation
cf auth $pcf_admin_username $pcf_admin_password
cf target -o $ORG -s $SPACE
if [[ "$EXECUTABLE_FILE" ]]; then
	chmod +x $EXECUTABLE_FILE
fi
cf push
