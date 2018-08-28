Set-PSDebug -Trace 1 -Strict

. .\SetEnvs.ps1
. .\SetEnvs-Local.ps1

$env:GITLAB_CPUS = 2  # 1,2
$env:GITLAB_MEMORY = 2289  # 1526,2289

Set-PSDebug -Off
