#!/bin/bash -e

unzip vault/*.zip
mv vault/vault* vault/vault
chmod +x vault/vault
export PATH=$PATH:$PWD/vault
