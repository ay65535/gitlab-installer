#!/bin/bash
set -eux

./destroy.sh
. ./setenvs-home.sh; set -eux
PATTERN='proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
env | egrep -i "$PATTERN" | sed -e 's/^/export /g' | sort
read -p "Press any key to continue.."
vagrant up --no-provision
vagrant reload --provision-with configure
vagrant reload --provision-with localize
vagrant halt
vagrant snapshot save configured
vagrant reload --provision-with install

set +eux
