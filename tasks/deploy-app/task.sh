#!/bin/bash -e

guid=$(om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products | jq -r '.[] | select(.type == "cf").guid')

om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products/$guid/manifest > pcf-manifest.json

export pcf_admin_username="admin"
export pcf_admin_password=$(cat pcf-manifest.json | jq -r '.instance_groups[] | select(.name=="uaa").properties.uaa.scim.users[] | select(.name=="admin").password')

cd app
erb < ./pcf-pipelines/manifests/$APP_NAME.erb > manifest.yml
cf auth $pcf_admin_username $pcf_admin_password
cf target -o $ORG -s $SPACE
cf push
