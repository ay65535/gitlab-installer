#!/bin/bash

set -eux

vagrant destroy --force gitlab
rm -rf ./gitlab
vagrant status
#vagrant global-status
#vagrant global-status --all
#vagrant box list
rm -rf ./.vagrant
