Set-PSDebug -Trace 1 -Strict

. .\SetEnvs.ps1
. .\SetEnvs-Local.ps1

$env:GITLAB_CPUS = 2
$env:GITLAB_MEMORY = 1749  # 1749,
$env:http_proxy = $env:proxy
$env:https_proxy = $env:proxy
$env:no_proxy = 'localhost,127.0.0.1,.sock,.local'
$env:HTTP_PROXY = "${env:http_proxy}"
$env:HTTPS_PROXY = "${env:https_proxy}"
$env:NO_PROXY = "${env:no_proxy}"

Set-PSDebug -Off
