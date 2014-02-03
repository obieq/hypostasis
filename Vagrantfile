# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'precise64'

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box_url = 'http://files.vagrantup.com/precise64.box'
    vb.memory = 4096
  end

  config.vm.provider :vmware_fusion do |vw, override|
    override.vm.box = 'precise64_vmware'
    override.vm.box_url = 'http://files.vagrantup.com/precise64_vmware.box'
    vw.memory = 4096
  end

  config.vm.provision 'shell', path: 'provision.sh'

  config.exec.root = '/vagrant'
  config.exec.prepend_with 'bundle exec'
end
