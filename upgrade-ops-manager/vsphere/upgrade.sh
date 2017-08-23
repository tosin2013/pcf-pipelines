#!/bin/bash

fly -t sdx-team sp -p upgrade-sdx-opsman -c <(yaml-patch -o ../../operations/use-different-git-repo.yml <pipeline.yml ) -l upgrade-ops-vars-sd.yml
