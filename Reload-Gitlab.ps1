$ErrorActionPreference = 'Stop'
Set-PSDebug -Strict -Trace 1

. .\Setenvs-Work.ps1
$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}
Pause; $ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1
vagrant ssh gitlab -- sudo gitlab-ctl stop
vagrant ssh gitlab -- sudo gitlab-ctl reconfigure
#vagrant ssh gitlab -- sudo gitlab-ctl restart
vagrant reload --no-provision
#vagrant reload --provision-with reconfigure
vagrant ssh gitlab -- sudo gitlab-ctl status

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
