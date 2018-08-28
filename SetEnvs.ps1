Set-PSDebug -Trace 1 -Strict

$env:GITLAB_PORT = 80
$env:GITLAB_SWAP = 8
$env:GITLAB_SWAPPINESS = 10
$env:GITLAB_CACHE_PRESSURE = 50
$env:GITLAB_PRIVATE_NETWORK = 0
$env:GITLAB_HOST = hostname
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

Set-PSDebug -Off
