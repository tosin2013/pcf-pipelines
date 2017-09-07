#!/bin/bash -e

cd release
bosh upload-release release.tgz
