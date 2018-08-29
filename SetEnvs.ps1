$ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

$env:GITLAB_PORT = 80
$env:GITLAB_SWAP = 8
$env:GITLAB_SWAPPINESS = 10
$env:GITLAB_CACHE_PRESSURE = 50
$env:GITLAB_PRIVATE_NETWORK = 1  # for nfs
$env:GITLAB_HOST = ([System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties() | Select -First 1  | foreach { "{0}.{1}" -F $_.HostName,$_.DomainName }).Trim('.')
$env:GITLAB_HOSTNAME = $env:GITLAB_HOST
$env:APT_MIRROR = 'http://ftp.jaist.ac.jp/pub/Linux/ubuntu/'
$env:SMB_USER = (whoami).Split('\')[1]
#$env:VAGRANT_DETECTED_OS = 'mingw'

if (!(Test-Path .\gitlab.rb.template)) {
    Invoke-WebRequest 'https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template' -OutFile 'gitlab.rb.template'
}

if (!(Test-Path .\gitlab.yml.example)) {
    Invoke-WebRequest 'https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example' -OutFile 'gitlab.yml.example'
}

if (!(Test-Path .\gitlab.rb)) {
    Copy-Item gitlab.rb.template gitlab.rb
}

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
