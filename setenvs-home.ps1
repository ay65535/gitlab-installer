. .\setenvs-local.ps1

$env:GITLAB_CPUS = 2  # 1,2
$env:GITLAB_PORT = 443
$env:GITLAB_MEMORY = 2289  # 1526,2289
$env:GITLAB_SWAP = 8
$env:GITLAB_SWAPPINESS = 10
$env:GITLAB_CACHE_PRESSURE = 50
$env:GITLAB_HOST = hostname
$env:GITLAB_HOSTNAME = $env:GITLAB_HOST
$env:APT_MIRROR = 'http://ftp.jaist.ac.jp/pub/Linux/ubuntu/'
$env:SMB_USER = (whoami).Split('\')[1]
#$env:VAGRANT_DETECTED_OS = 'mingw'

$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}

if (!(Test-Path .\gitlab.rb.template)) {
    Invoke-WebRequest 'https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template' -OutFile 'gitlab.rb.template'
}

if (!(Test-Path .\gitlab.yml.example)) {
    Invoke-WebRequest 'https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example' -OutFile 'gitlab.yml.example'
}

if (!(Test-Path .\gitlab.rb)) {
    Copy-Item gitlab.rb.template gitlab.rb
}
