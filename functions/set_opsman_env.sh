#!/bin/bash -e

source ./pcf-pipelines/functions/init-vault.sh

export OPSMAN_URL=$(vault read -field=opsman-url secret/opsman-$FOUNDATION_NAME-props)
export OPSMAN_USER=$(vault read -field=opsman-user secret/opsman-$FOUNDATION_NAME-props)
export OPSMAN_PASSWORD=$(vault read -field=opsman-password secret/opsman-$FOUNDATION_NAME-props)
