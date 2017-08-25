#!/bin/bash -e

yaml-patch -o ../../operations/use-different-git-repo.yml <pipeline.yml > tmp-pipeline.yml
sed -i -e "s/{{/((/g" -e "s/}}/))/g" tmp-pipeline.yml 

fly-sb -t sandbox sp -p install-sdx-opsman-n-cf -c tmp-pipeline.yml 
#rm tmp-pipeline.yml
