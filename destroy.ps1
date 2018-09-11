$ErrorActionPreference = 'Stop'
Set-PSDebug -Strict -Trace 1

vagrant destroy --force gitlab
if (Test-Path .\gitlab\) {
    Remove-Item -Recurse -Force .\gitlab\
}
vagrant status
if (Test-Path .\.vagrant\) {
    Remove-Item -Recurse -Force .\.vagrant\
}
if (Test-Path .\gitlab.rb.template) {
    Remove-Item .\gitlab.rb.template
}
if (Test-Path .\gitlab.yml.example) {
    Remove-Item .\gitlab.yml.example
}

$ErrorActionPreference = 'Continue'; Set-PSDebug -Off
