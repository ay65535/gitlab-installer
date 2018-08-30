$ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

. .\SetEnvs-Home.ps1
$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}
Pause
#vagrant ssh default -- sudo gitlab-ctl status
#vagrant ssh default -- sudo gitlab-ctl stop
vagrant halt
VBoxManage list runningvms
if (Test-Path .\gitlab) {
    Remove-Item -Recurse -Force .\gitlab\
}
vagrant snapshot restore configured --no-provision
vagrant provision --provision-with install

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
