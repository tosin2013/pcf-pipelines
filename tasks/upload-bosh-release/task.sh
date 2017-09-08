#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh

cd release
bosh upload-release release.tgz
