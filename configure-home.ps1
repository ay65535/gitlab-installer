. .\configure-local.ps1

$env:GITLAB_CPUS = 1
$env:GITLAB_PORT = 443
$env:GITLAB_MEMORY = 1526
#$env:GITLAB_MEMORY = 2048
#$env:GITLAB_MEMORY = 3072
$env:GITLAB_SWAP = 3
#$env:GITLAB_HOST = '127.0.0.1'  # bad
#$env:GITLAB_HOST = '192.168.0.2'
#$env:GITLAB_HOST = 'localhost'
$env:GITLAB_HOSTNAME = $env:GITLAB_HOST
$env:EXTERNAL_URL = $env:GITLAB_HOSTNAME
#$env:VAGRANT_DETECTED_OS = 'mingw'

Get-ChildItem env:\ | Where-Object {$_.Key -imatch "proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG)"}

Invoke-WebRequest 'https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template' -OutFile 'gitlab.rb.template'
Invoke-WebRequest 'https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example' -OutFile 'gitlab.yml.example'
#Copy-Item gitlab.rb.template gitlab.rb
