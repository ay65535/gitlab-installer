#!/bin/bash

export http_proxy=$proxy
export https_proxy=$proxy
export no_proxy='localhost,127.0.0.1,.sock,.local'

export HTTP_PROXY="${http_proxy}"
export HTTPS_PROXY="${https_proxy}"
export NO_PROXY="${no_proxy}"

export VAGRANT_DETECTED_OS='mingw'

export GITLAB_MEMORY=1749
export GITLAB_CPUS=2
export GITLAB_PORT=443
export GITLAB_SWAP=4
export GITLAB_HOST=gitlab.local
export GITLAB_EDITION="community"
export GITLAB_PRIVATE_NETWORK=0

env | col | sort | grep -vE 'PATH|PWD' | grep -iE 'proxy|^(VAGRANT|GITLAB|MINGW|MSYS|CYG)'

curl -sO https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
curl -sO https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example
cp gitlab.rb.template gitlab.rb
