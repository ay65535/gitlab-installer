#!/bin/bash
set -eux

export GITLAB_PORT=80
export GITLAB_SWAP=2
export GITLAB_SWAPPINESS=10
export GITLAB_CACHE_PRESSURE=50
export GITLAB_PRIVATE_NETWORK=1  # 1 for nfs
export GITLAB_HOST=${GITLAB_HOST:-`hostname`}
export GITLAB_HOSTNAME=$GITLAB_HOST
export APT_MIRROR='http://ftp.jaist.ac.jp/pub/Linux/ubuntu/'
case "$OSTYPE" in
    darwin*|linux*) export SMB_USER=${USER} ;;
                 *) export SMB_USER=${USERNAME} ;;
esac
#export VAGRANT_DETECTED_OS='mingw'

if [ ! -e ./gitlab.rb.template ]; then
    curl -sO 'https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template'
fi

if [ ! -e ./gitlab.yml.example ]; then
    curl -sO 'https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example'
fi

if [ ! -e ./gitlab.rb ]; then
    cp gitlab.rb.template gitlab.rb
fi

set +eux
