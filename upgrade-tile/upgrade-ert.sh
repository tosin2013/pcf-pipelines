#!/bin/bash 

fly -t sdx-team sp -p upgrade-sdx-ert -c <(yaml-patch -o ../operations/use-different-git-repo.yml <pipeline.yml ) -l upgrade-ert-vars-sd.yml 
