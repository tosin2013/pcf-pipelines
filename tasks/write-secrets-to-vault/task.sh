#!/bin/bash

set -eu

source ./pcf-pipelines/functions/init-vault.sh

echo "Writing opsmanager secrets to vault"

vault write secret/opsman-$FOUNDATION_NAME-props \
  opsman-url=https://${OPSMAN_DOMAIN_OR_IP_ADDRESS} \
  opsman-user=${OPSMAN_USERNAME} \
  opsman-password=${OPSMAN_PASSWORD}

echo "Writing bosh secrets to vault"

om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/director/manifest > bosh-manifest.json

bosh_ip=$(cat bosh-manifest.json  | jq -r ".jobs[0].networks[0].static_ips[0]") #ops manager always deploy single node for bosh director
bosh_cacert=$(cat bosh-manifest.json  | jq -r ".jobs[0].properties.director.config_server.ca_cert")
bosh_client_secret=$(cat bosh-manifest.json  | jq -r ".jobs[0].properties.uaa.clients.bbr_client.secret")

vault write secret/bosh-$FOUNDATION_NAME-props \
  bosh-cacert=$bosh_cacert \
  bosh-client-id=bbr_client \
  bosh-client-secret=$bosh_client_secret \
  bosh-url="https://$bosh_ip" 

echo "Writing PCF secrets to vault"

guid=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products | jq -r '.[] | select(.type == "cf").guid')

om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products/$guid/manifest > pcf-manifest.json

pcf_api_url=$(cat pcf-manifest.json | jq -r '.instance_groups[] | select(.name=="cloud_controller").properties.route_registrar.routes[0].uris[0]')
pcf_admin_user_password=$(cat pcf-manifest.json | jq -r '.instance_groups[] | select(.name=="uaa").properties.uaa.scim.users[] | select(.name=="admin").password')

vault write secret/pcf-$FOUNDATION_NAME-props \
  pcf-api-url=https://$pcf_api_url \
  pcf-admin-user=admin \
  pcf-admin-user-password=$pcf_admin_user_password
