#!/usr/bin/env bash
# Copyright (c) 2013-2016 Tuomo Tanskanen <tuomo@tanskanen.org>

# Usage: Copy 'gitlab.rb.example' as 'gitlab.rb', then 'vagrant up'.

set -ex

# these are normally passed via Vagrantfile to environment
# but if you run this on bare metal they need to be reset
GITLAB_HOSTNAME=${GITLAB_HOSTNAME:-127.0.0.1}
GITLAB_PORT=${GITLAB_PORT:-8443}

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
    if [[ $GITLAB_EDITION == "community" ]]; then
        GITLAB_PACKAGE=gitlab-ce
    elif [[ $GITLAB_EDITION == "enterprise" ]]; then
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

rewrite_hostname()
{
    sed -i -e "s,^external_url.*,external_url 'https://${GITLAB_HOSTNAME}/'," /etc/gitlab/gitlab.rb
}

# All commands expect root access.
check_for_root

# Check that the GitLab edition which is defined is supported and set package name
set_gitlab_edition

# Check for configs that are not compatible anymore
check_for_gitlab_rb
check_for_backwards_compatibility

echo "Installing ${GITLAB_PACKAGE} via apt ..."
test ! -d /etc/gitlab && mkdir -p /etc/gitlab
cp /vagrant/gitlab.rb /etc/gitlab/gitlab.rb
if [[ ${GITLAB_PORT} == 80 ]]; then
    export EXTERNAL_URL="http://${GITLAB_HOSTNAME}/"
elif [[ ${GITLAB_PORT} == 443 ]]; then
    export EXTERNAL_URL="https://${GITLAB_HOSTNAME}/"
else
    export EXTERNAL_URL="https://${GITLAB_HOSTNAME}:${GITLAB_PORT}/"
fi
apt-get install -y ${GITLAB_PACKAGE}

# fix the config and reconfigure
#cp /vagrant/gitlab.rb /etc/gitlab/gitlab.rb
#rewrite_hostname
#gitlab-ctl reconfigure

# done
echo "Done!"
echo " Login at ${EXTERNAL_URL}, username 'root'. Password will be reset on first login."
echo " Config found at /etc/gitlab/gitlab.rb and updated by 'sudo gitlab-ctl reconfigure'"
