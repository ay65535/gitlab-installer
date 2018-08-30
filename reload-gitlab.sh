#!/bin/bash
set -eux

. ./setenvs-home.sh
PATTERN='proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
env | egrep -i "$PATTERN" | sed -e 's/^/export /g' | sort
read -p "Press any key to continue.."
vagrant ssh gitlab -- sudo gitlab-ctl stop
vagrant ssh gitlab -- sudo gitlab-ctl reconfigure
#vagrant ssh gitlab -- sudo gitlab-ctl restart
vagrant reload --no-provision
#vagrant reload --provision-with reconfigure
vagrant ssh gitlab -- sudo gitlab-ctl status

set +eux
