vagrant destroy --force gitlab
Remove-Item -Recurse -Force .\gitlab\
vagrant status
#vagrant global-status
#vagrant global-status --all
#vagrant box list
Remove-Item -Recurse -Force .\.vagrant\
