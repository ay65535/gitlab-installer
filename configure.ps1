$env:http_proxy = $proxy
$env:https_proxy = $proxy
$env:no_proxy = 'localhost,127.0.0.1,.sock,.local'

$env:HTTP_PROXY = "${env:http_proxy}"
$env:HTTPS_PROXY = "${env:https_proxy}"
$env:NO_PROXY = "${env:no_proxy}"

#$env:VAGRANT_DETECTED_OS = 'mingw'

$env:GITLAB_CPUS = 2
$env:GITLAB_PORT = 8443
$env:GITLAB_MEMORY = 1749
$env:GITLAB_SWAP = 4
$env:GITLAB_HOST = 'gitlab.local'

Get-ChildItem env:\ | Where-Object {$_.Key -imatch "proxy|^(VAGRANT|GITLAB|MINGW|MSYS|CYG)"}

Invoke-WebRequest https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template -OutFile gitlab.rb.template
Invoke-WebRequest https://gitlab.com/gitlab-org/gitlab-ce/raw/master/config/gitlab.yml.example -OutFile gitlab.yml.example
Copy-Item gitlab.rb.template gitlab.rb
