#!/bin/bash

set -eux

vagrant destroy --force gitlab
rm -rf ./gitlab
vagrant status
rm -rf ./.vagrant
