set -ex; . ./setenvs-local.sh

export GITLAB_CPUS=2  #1,2
export GITLAB_PORT=443
export GITLAB_MEMORY=4096  # 1526,2289
export GITLAB_SWAP=8
export GITLAB_SWAPPINESS=10
export GITLAB_CACHE_PRESSURE=50
export GITLAB_PRIVATE_NETWORK=0
export GITLAB_HOST='localhost'
export GITLAB_HOSTNAME=$GITLAB_HOST
export APT_MIRROR='http://ftp.jaist.ac.jp/pub/Linux/ubuntu/'
export SMB_USER="$USER"
#$export VAGRANT_DETECTED_OS='mingw'

if [ ! -e ./gitlab.rb.template ]; then
    curl -sO 'https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template'
fi

if [ ! -e ./gitlab.yml.example ]; then
    curl -sO 'https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example'
fi

if [ ! -e ./gitlab.rb ]; then
    cp gitlab.rb.template gitlab.rb
fi

set +ex
