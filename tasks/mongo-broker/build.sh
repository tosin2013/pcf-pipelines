#!/usr/bin/env bash
set -e

# you need to have java, mvn, ruby, bundler
pushd broker-repo
./gradlew build -x test  
popd

mv broker-repo/build/libs/cloudfoundry-mongodb-service-broker.jar binary
