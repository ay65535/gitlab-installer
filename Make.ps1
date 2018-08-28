Set-PSDebug -Trace 1 -Strict

.\Destroy.ps1
. .\SetEnvs-Home.ps1
vagrant up --no-provision
vagrant reload --provision-with configure
vagrant reload --provision-with localize
vagrant halt
vagrant snapshot save configured
$Pattern = 'proxy|EXTERNAL_URL|^(VAGRANT|GITLAB|MINGW|MSYS|CYG|SMB_USER|APT|EXTERNAL)'
Get-ChildItem env:\ | Where-Object {$_.Key -imatch "$Pattern"}
read -p "Press any key to continue.."
vagrant reload --provision-with install

Set-PSDebug -Off
