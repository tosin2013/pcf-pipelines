#!/bin/bash 

yaml-patch -o ../operations/use-different-git-repo.yml <pipeline.yml > tmp-pipeline.yml

fly-sb -t sandbox sp -p upgrade-sdx-ert -c tmp-pipeline.yml -l upgrade-ert-vars-sd.yml
