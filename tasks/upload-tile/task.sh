#!/bin/bash -e

source ./pcf-pipelines/functions/set-opsman-env.sh

FILE_PATH=`find ./pivnet-product -name *.pivotal`
om-linux -t $OPSMAN_URL -u $OPSMAN_USER -p $OPSMAN_PASSWORD -k --request-timeout 3600 upload-product -p $FILE_PATH
