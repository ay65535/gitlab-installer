#!/bin/bash
set -ex

./destroy.sh
. ./setenvs-home.sh
vagrant up --no-provision
vagrant reload --provision-with configure
vagrant reload --provision-with localize
vagrant halt
vagrant snapshot save configured
PATTERN='proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
env | egrep -i "$PATTERN" | sed -e 's/^/export /g' | sort
read -p "Press any key to continue.."
vagrant reload --provision-with install

set +ex
