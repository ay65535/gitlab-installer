#!/usr/bin/env bash
# Copyright (c) 2013-2016 Tuomo Tanskanen <tuomo@tanskanen.org>
# Copyright (c) 2018 ay65535 <ay65535@icloud.com>

# Usage: Copy 'gitlab.rb.example' as 'gitlab.rb', then 'vagrant up'.

set -ex

# these are normally passed via Vagrantfile to environment
# but if you run this on bare metal they need to be reset
GITLAB_HOSTNAME=${GITLAB_HOSTNAME:-127.0.0.1}
APT_MIRROR=${APT_MIRROR:-http://ftp.jaist.ac.jp/pub/Linux/ubuntu/}
GITLAB_SWAPPINESS=${GITLAB_SWAPPINESS:-60}
GITLAB_CACHE_PRESSURE=${GITLAB_CACHE_PRESSURE:-100}

#
#  --------------------------------
#  Installation - no need to touch!
#  --------------------------------
#

export DEBIAN_FRONTEND=noninteractive

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

check_for_gitlab_rb()
{
    if [[ ! -e /vagrant/gitlab.rb ]]; then
        fatal "gitlab.rb not found at /vagrant"
        exit 1
    fi
}

set_gitlab_edition()
{
    if [[ ${GITLAB_EDITION} == "community" ]]; then
        GITLAB_PACKAGE=gitlab-ce
    elif [[ ${GITLAB_EDITION} == "enterprise" ]]; then
        GITLAB_PACKAGE=gitlab-ee
    else
        fatal "\"${GITLAB_EDITION}\" is not a supported GitLab edition"
        exit 1
    fi
}

check_for_backwards_compatibility()
{
    if egrep -q "^ci_external_url" /vagrant/gitlab.rb; then
        fatal "ci_external_url setting detected in 'gitlab.rb'"
        fatal "This setting is deprecated in Gitlab 8.0+, and will cause Chef to fail."
        fatal "Check the 'gitlab.rb.example' for fresh set of settings."
        exit 1
    fi
}

set_apt_pdiff_off()
{
    echo 'Acquire::PDiffs "false";' > /etc/apt/apt.conf.d/85pdiff-off
}

set_fastest_mirror()
{
    if [[ ! -f /etc/apt/sources.list.bak ]]; then
        sed -i.bak -e "s%http://[^ ]\+%${APT_MIRROR}%g" /etc/apt/sources.list
    fi
}

install_swap_file()
{
    # "GITLAB_SWAP" is passed in environment by shell provisioner
    SWAP_FILE=/.swap.file
    if [[ -e ${SWAP_FILE} ]]; then
        echo "Skipped swap file creation due /.swap.file already available"
    elif [[ ${GITLAB_SWAP} > 0 ]]; then
        echo "Creating swap file of ${GITLAB_SWAP}G size"
        #dd if=/dev/zero of=${SWAP_FILE} bs=1G count=$GITLAB_SWAP
        fallocate -l ${GITLAB_SWAP}G ${SWAP_FILE}
        mkswap ${SWAP_FILE}
        cp -p /etc/fstab /etc/fstab.bak
        echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
        chmod 600 ${SWAP_FILE}
        swapon -a
    else
        echo "Skipped swap file creation due 'GITLAB_SWAP' set to 0"
    fi
}

change_swappiness()
{
    if [[ ${GITLAB_SWAPPINESS} -ne 60 ]]; then
        cp --backup=existing -f /etc/sysctl.conf /etc/sysctl.conf
        echo "vm.swappiness=$GITLAB_SWAPPINESS" >> /etc/sysctl.conf
        sysctl vm.swappiness=${GITLAB_SWAPPINESS}
    fi
}

change_vfs_cache_pressure()
{
    if [[ ${GITLAB_CACHE_PRESSURE} -ne 100 ]]; then
        cp --backup=existing -f /etc/sysctl.conf /etc/sysctl.conf
        echo "vm.vfs_cache_pressure=$GITLAB_CACHE_PRESSURE" >> /etc/sysctl.conf
        sysctl vm.vfs_cache_pressure=${GITLAB_CACHE_PRESSURE}
    fi
}

# All commands expect root access.
check_for_root

# Check that the GitLab edition which is defined is supported and set package name
set_gitlab_edition

# Check for configs that are not compatible anymore
check_for_gitlab_rb
check_for_backwards_compatibility

# install swap file for more memory
install_swap_file
change_swappiness
change_vfs_cache_pressure

# install tools to automate this install
set_fastest_mirror ${APT_MIRROR}
apt-get -y update
apt-get -y upgrade
apt-get -y install debconf-utils curl

# install the few dependencies we have
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $GITLAB_HOSTNAME" | debconf-set-selections
apt-get -y install openssh-server postfix

# generate ssl keys
apt-get -y install ca-certificates ssl-cert
make-ssl-cert generate-default-snakeoil --force-overwrite

# download omnibus-gitlab package (300M) with apt
# vagrant-cachier plugin highly recommended
echo "Setting up Gitlab deb repository ..."
set_apt_pdiff_off
if ! dpkg -l ${GITLAB_PACKAGE}; then
    curl -s https://packages.gitlab.com/install/repositories/gitlab/${GITLAB_PACKAGE}/script.deb.sh | sudo bash
fi

# done
echo "Done!"
