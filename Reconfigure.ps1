$ErrorActionPreference = 'Stop'
Set-PSDebug -Strict -Trace 1

. .\SetEnvs-Work.ps1
$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}
Pause; $ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1
vagrant reload --provision-with reconfigure
vagrant ssh gitlab -- sudo gitlab-ctl restart
vagrant ssh gitlab -- sudo gitlab-ctl status

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
