#!/bin/bash
set -e

yaml-patch -o ../operations/use-different-git-repo.yml <pipeline.yml >tmp-pipeline.yml

$FLYCMD -t $CONCOURSE_TARGET sp -p install-sdx-redis -c tmp-pipeline.yml -l vars-p-redis.yml
