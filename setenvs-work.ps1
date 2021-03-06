$ErrorActionPreference = 'Stop'
Set-PSDebug -Strict -Trace 1

Remove-Item Env:\*GITLAB_*
Remove-Item Env:\SMB_*
Remove-Item Env:\APT_*
. .\SetEnvs-Local.ps1
. .\SetEnvs.ps1; $ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

$env:GITLAB_CPUS = 2
$env:GITLAB_MEMORY = 2798  # 1749,2798
$env:http_proxy = $env:proxy
$env:https_proxy = $env:proxy
$env:no_proxy = "localhost,127.0.0.1,.sock,.local,${env:no_proxy}"
$env:HTTP_PROXY = "${env:http_proxy}"
$env:HTTPS_PROXY = "${env:https_proxy}"
$env:NO_PROXY = "${env:no_proxy}"

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
