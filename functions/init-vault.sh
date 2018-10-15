#!/bin/bash -e

unzip vault/vault.zip -d vault/
chmod +x vault/vault
export PATH=$PATH:$PWD/vault
export VAULT_SKIP_VERIFY=true
