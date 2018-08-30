#!/bin/bash
set -eux

. ./setenvs.sh
. ./setenvs-local.sh

export GITLAB_CPUS=2  #1,2
export GITLAB_MEMORY=2289  # 1526,2289

set +eux
