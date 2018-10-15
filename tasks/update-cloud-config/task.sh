#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh

bosh cloud-config > cc.yml

./pcf-pipelines/tasks/update-cloud-config/modify-cloud-config.rb < cc.yml > cc-updated.yml

bosh -n update-cloud-config cc-updated.yml

