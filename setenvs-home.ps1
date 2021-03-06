$ErrorActionPreference = 'Stop'
Set-PSDebug -Strict -Trace 1

Remove-Item Env:\*GITLAB_*
Remove-Item Env:\SMB_*
Remove-Item Env:\APT_*
. .\SetEnvs-Local.ps1; $ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1
. .\SetEnvs.ps1; $ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

$env:GITLAB_CPUS = 2  # 1,2
$env:GITLAB_MEMORY = 2048  # 1526,2289

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
