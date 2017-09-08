#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh

bosh cloud-config > cc.yml
python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < cc.yaml > cc.json

cat cc.json | jq ".networks[] | select(.name == \"SERVICES\").subnets[0].static |= . + \"$SERVICES_NETWORK_STATIC_IPS\""  > cc-updated.json

python -c 'import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < cc-updated.json > cc-updated.yml

bosh -n update-cloud-config cc-updated.yml

