# -*- mode: ruby -*-
# vi: set ft=ruby :
# Copyright (c) 2013-2017 Tuomo Tanskanen <tuomo@tanskanen.org>

# read configurable cpu/memory/port/swap/host/edition settings from environment variables
memory = ENV['GITLAB_MEMORY'] || 3072
cpus = ENV['GITLAB_CPUS'] || 2
port = ENV['GITLAB_PORT'] || 8443
swap = ENV['GITLAB_SWAP'] || 0
host = ENV['GITLAB_HOST'] || 'gitlab.local'
edition = ENV['GITLAB_EDITION'] || 'community'
private_network = ENV['GITLAB_PRIVATE_NETWORK'] || 0
proxy = ENV['http_proxy'] || nil
noproxy = ENV['no_proxy'] || nil
smb_user = ENV['SMB_USER'] || nil
smb_pass = ENV['SMB_PASS'] || nil
envs = {
  GITLAB_SWAP: swap,
  GITLAB_HOSTNAME: host,
  GITLAB_PORT: port,
  GITLAB_EDITION: edition,
  http_proxy: proxy,
  HTTP_PROXY: proxy,
  https_proxy: proxy,
  HTTPS_PROXY: proxy,
  no_proxy: noproxy,
  NO_PROXY: noproxy
}

# for /var/opt/gitlab/git-data
mount_option_gitdata = %w[dmode=0700 fmode=0644 uid=997 gid=0]
# for /var/opt/gitlab/git-data/repositories
mount_option_gitdata_repositories = %w[dmode=2770 fmode=0644 uid=997 gid=997 suid]
# for /var/opt/gitlab/gitlab-rails/shared
mount_option_gitlabrails_shared = %w[dmode=0751 uid=997 gid=998]
# for /var/opt/gitlab/gitlab-rails/shared/artifacts
mount_option_gitlabrails_shared_artifacts = %w[dmode=0700 uid=997 gid=0]
# for /var/opt/gitlab/gitlab-rails/shared/lfs-objects
mount_option_gitlabrails_shared_lfsobjects = %w[dmode=0700 uid=997 gid=0]
# for /var/opt/gitlab/gitlab-rails/uploads
mount_option_gitlabrails_uploads = %w[dmode=0700 uid=997 gid=0]
# for /var/opt/gitlab/gitlab-rails/shared/pages
mount_option_gitlabrails_shared_pages = %w[dmode=0750 uid=997 gid=998]
# for /var/opt/gitlab/gitlab-ci/builds
mount_option_gitlabci_builds = %w[dmode=0700 uid=997 gid=0]
# for /var/opt/gitlab/.ssh
mount_option_dotssh = %w[dmode=0700 fmode=600 uid=997 gid=997]

mount_option_prom_root = %w[uid=994 gid=0 dmode=755 fmode=644]
mount_option_root_root = %w[uid=0 gid=0 dmode=755 fmode=644]
mount_option_git_www = %w[uid=997 gid=998 dmode=755 fmode=644]
mount_option_root_www = %w[uid=0 gid=998 dmode=755 fmode=644]
mount_option_psql_root = %w[uid=995 gid=0 dmode=755 fmode=644]
mount_option_redis_git = %w[uid=996 gid=997 dmode=755 fmode=644]
mount_option_everyone = %w[uid=1000 gid=1000 dir_mode=0777 file_mode=0777]

Vagrant.require_version '>= 1.8.0'

Vagrant.configure('2') do |config|
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  config.vm.define :gitlab do |conf|
    required_plugins = %w[vagrant-global-status vagrant-vbguest vagrant-cachier vagrant-proxyconf vagrant-disksize]
    need_retry = false
    required_plugins.each do |plugin|
     unless Vagrant.has_plugin? plugin
       system "vagrant plugin install #{plugin}"
       need_retry = true
     end
    end
    exec 'vagrant ' + ARGV.join(' ') if need_retry
    conf.proxy.http = proxy
    conf.proxy.https = proxy
    conf.proxy.no_proxy = noproxy

    # Configure some hostname here
    conf.vm.hostname = host
    # bento/ubuntu-16.04 provides boxes for virtualbox. vmware_desktop(fusion, workstation) and parallels
    conf.vm.box = 'bento/ubuntu-16.04'
    conf.vm.provision 'localize', type: 'shell', path: 'localize.sh', env: envs
    conf.vm.provision 'configure', type: 'shell', path: 'configure-gitlab.sh', env: envs
    conf.vm.provision 'install', type: 'shell', path: 'install-gitlab.sh', env: envs

    # On Linux, we cannot forward ports <1024
    # We need to use higher ports, and have port forward or nginx proxy
    # or access the site via hostname:<port>, in this case 127.0.0.1:8080
    # By default, Gitlab is at https + port 8443
    conf.vm.network :forwarded_port, guest: 443, host: port
    conf.vm.network 'private_network', type: 'dhcp' if private_network == '1'

    # use rsync for synced folder to avoid the need for provider tools
    # added rsync__auto  to enable detect changes on host and sync to guest machine and exclude .git/
    conf.vm.synced_folder '.', '/vagrant', type: 'rsync', rsync__exclude: %w[.git/ gitlab/], rsync__auto: true
    conf.vm.synced_folder 'gitlab/conf', '/etc/gitlab', create: true
    conf.vm.synced_folder 'gitlab/logs', '/var/log/gitlab', create: true
    conf.vm.synced_folder 'gitlab/data', '/var/opt/gitlab', create: true, type: 'smb', smb_username: smb_user, smb_password: smb_pass,
                          mount_options: mount_option_everyone

    # conf.vm.synced_folder 'gitlab/data/git-data',
    #                       '/var/opt/gitlab/git-data', create: true, mount_options: mount_option_gitdata
    # conf.vm.synced_folder 'gitlab/data/git-data/repositories',
    #                       '/var/opt/gitlab/git-data/repositories', create: true, mount_options: mount_option_gitdata_repositories
    # conf.vm.synced_folder 'gitlab/data/gitlab-rails/shared',
    #                       '/var/opt/gitlab/gitlab-rails/shared', create: true, mount_options: mount_option_gitlabrails_shared
    # conf.vm.synced_folder 'gitlab/data/gitlab-rails/shared/artifacts',
    #                       '/var/opt/gitlab/gitlab-rails/shared/artifacts', create: true, mount_options: mount_option_gitlabrails_shared_artifacts
    # conf.vm.synced_folder 'gitlab/data/gitlab-rails/shared/lfs-objects',
    #                       '/var/opt/gitlab/gitlab-rails/shared/lfs-objects', create: true, mount_options: mount_option_gitlabrails_shared_lfsobjects
    # conf.vm.synced_folder 'gitlab/data/gitlab-rails/uploads',
    #                       '/var/opt/gitlab/gitlab-rails/uploads', create: true, mount_options: mount_option_gitlabrails_uploads
    # conf.vm.synced_folder 'gitlab/data/gitlab-rails/shared/pages',
    #                       '/var/opt/gitlab/gitlab-rails/shared/pages', create: true, mount_options: mount_option_gitlabrails_shared_pages
    # conf.vm.synced_folder 'gitlab/data/gitlab-ci/builds',
    #                       '/var/opt/gitlab/gitlab-ci/builds', create: true, mount_options: mount_option_gitlabci_builds
    # conf.vm.synced_folder 'gitlab/data/.ssh',
    #                       '/var/opt/gitlab/.ssh', create: true, mount_options: mount_option_dotssh
  end

  # GitLab recommended specs
  config.vm.provider 'virtualbox' do |v|
    v.cpus = cpus
    v.memory = memory
    #conf.disksize.size = '20GB'
    #v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/gitlab/logs", "1"]
  end

  # vmware Workstation and Fusion Provider this will work for both vmware versions as the virtual machines
  # images are identical is a fuzzy term which will allow both to work effectively for ether Fusion for the
  # Mac or Workstation for the PC. It only matters which provider is specified on vagrant up command
  # (--provider=vmware_fusion or --provider=vmware_workstation)
  # vmware provider requires hashicorp license https://www.vagrantup.com/vmware/index.html
  config.vm.provider 'vmware_desktop' do |v|
    v.vmx['memsize'] = memory.to_s
    v.vmx['numvcpus'] = cpus.to_s
  end

  config.vm.provider 'parallels' do |v|
    v.cpus = cpus
    v.memory = memory
  end

  config.vm.provider 'lxc' do |_v, override|
    override.vm.box = 'developerinlondon/ubuntu_lxc_xenial_x64'
  end
end
