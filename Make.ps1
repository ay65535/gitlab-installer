$ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

.\Destroy.ps1
. .\SetEnvs-Work.ps1
vagrant up --no-provision
vagrant reload --provision-with configure
vagrant reload --provision-with localize
vagrant halt
vagrant snapshot save configured
$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}
Pause
vagrant reload --provision-with install

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
