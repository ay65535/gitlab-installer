#!/usr/bin/env bash
# Copyright (c) 2018 ay65535 <ay65535@icloud.com>

set -ex

#
#  --------------------------------
#  Installation - no need to touch!
#  --------------------------------
#

fatal()
{
    echo "fatal: $@" >&2
}

check_for_root()
{
    if [[ $EUID != 0 ]]; then
        fatal "need to be root"
        exit 1
    fi
}

# All commands expect root access.
check_for_root

# install tools to automate this install
apt-get -y update
apt-get -y install language-pack-ja-base
#apt-get -y install language-pack-ja-base language-pack-ja
localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
localectl set-keymap jp106
source /etc/default/locale
timedatectl set-timezone Asia/Tokyo
localectl
timedatectl
date

# done
echo "Done!"
