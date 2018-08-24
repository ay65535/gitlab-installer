set -eux; . ./configure-local.sh

export GITLAB_CPUS=2
export GITLAB_PORT=443
export GITLAB_MEMORY=4096  # 1526,2289
export GITLAB_SWAP=8
export GITLAB_SWAPPINESS=10
export GITLAB_CACHE_PRESSURE=50
export GITLAB_HOSTNAME=$GITLAB_HOST
export EXTERNAL_URL="https://$GITLAB_HOSTNAME"
export APT_MIRROR='http://ftp.jaist.ac.jp/pub/Linux/ubuntu/'
#$export VAGRANT_DETECTED_OS='mingw'

env | egrep -i "proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)" | sed -e 's/^/export /g' | sort
