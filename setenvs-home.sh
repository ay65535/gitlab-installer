#!/bin/bash
set -eux

unset GITLAB_*
unset SMB_*
unset APT*
. ./setenvs-local.sh; set -eux
. ./setenvs.sh; set -eux

export GITLAB_CPUS=2  #1,2
export GITLAB_MEMORY=8192  # 1526,2289,8192

set +eux
