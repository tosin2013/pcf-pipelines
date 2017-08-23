#!/bin/bash -e

yaml-patch -o ../../operations/use-different-git-repo.yml -o ../../operations/add-write-to-vault.yml <pipeline.yml > tmp-pipeline.yml
fly -t sdx-team sp -p install-sdx-opsman-n-cf -c tmp-pipeline.yml -l install-pcf-vars-sd.yml
#rm tmp-pipeline.yml
