#!/bin/bash
set -eux

vagrant destroy --force gitlab
if [[ -d ./gitlab ]]; then
	rm -rf ./gitlab
fi
vagrant status
if [[ -d ./.vagrant ]]; then
	rm -rf ./.vagrant
fi

set +eux
