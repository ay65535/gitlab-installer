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
if [[ ./gitlab.rb.template ]]; then
    rm ./gitlab.rb.template
fi
if [[ ./gitlab.yml.example ]]; then
    rm ./gitlab.yml.example
fi

set +eux
