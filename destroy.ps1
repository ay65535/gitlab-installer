$ErrorActionPreference = 'Stop'; Set-PSDebug -Strict -Trace 1

vagrant destroy --force gitlab
if (Test-Path .\gitlab) {
    Remove-Item -Recurse -Force .\gitlab\
}
vagrant status
if (Test-Path .\.vagrant\) {
    Remove-Item -Recurse -Force .\.vagrant\
}

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
