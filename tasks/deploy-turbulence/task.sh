#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh

erb < ../pcf-pipelines/bosh-manifests/turbulence.yml.erb > manifest.yml

bosh -n -d turbulence deploy manifest.yml \
  -v turbulence_api_ip=$TURBULENCE_API_IP \
  -v director_ip=$BOSH_IP \
  --var-file director_ssl_ca=$DIRECTOR_CA_CERT \
  -v director_client=$BOSH_CLIENT \
  -v director_client_secret=$BOSH_CLIENT_SECRET \
  --vars-store ./creds.yml
