#!/bin/bash -e

export BOSH_CLIENT=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -p /api/v0/deployed/director/credentials/uaa_bbr_client_credentials | jq -r ".credential.value.identity")

export BOSH_CLIENT_SECRET=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/deployed/director/credentials/uaa_bbr_client_credentials | jq -r ".credential.value.password")

export BOSH_CA_CERT=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/certificate_authorities | jq -r ".certificate_authorities[] | select(.active==true).cert_pem")


export BOSH_ENVIRONMENT=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/deployed/director/manifest | jq -r ".jobs[0].networks[0].static_ips[0]")

