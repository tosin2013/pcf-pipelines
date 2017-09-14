#!/usr/bin/env bash
set -e

# you need to have java, mvn, ruby, bundler
pushd broker-repo
./gradlew -x test  
popd

mv chaos-loris-repo/target/cloudfoundry-mongodb-service-broker.jar binary
