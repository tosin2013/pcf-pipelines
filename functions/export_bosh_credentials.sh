#!/bin/bash -e

export bosh_user=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -p  /api/v0/deployed/director/credentials/director_credentials | jq -r ".credential.value.identity")

export bosh_password=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -p  /api/v0/deployed/director/credentials/director_credentials | jq -r ".credential.value.password")

export bosh_client=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -p /api/v0/deployed/director/credentials/uaa_bbr_client_credentials | jq -r ".credential.value.identity")

export bosh_client_secret=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/deployed/director/credentials/uaa_bbr_client_credentials | jq -r ".credential.value.password")

export bosh_ca=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/certificate_authorities | jq -r ".certificate_authorities[] | select(.active==true).cert_pem")


export bosh_ip=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl  -p /api/v0/deployed/director/manifest | jq -r ".jobs[0].networks[0].static_ips[0]")

