# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true

  config.vm.define "control" do |control|
    control.vm.box = "ubuntu/xenial64"
    control.vm.hostname = "control"
    control.vm.network "private_network", ip: "192.168.33.2"
    control.vm.synced_folder "~/.config/gcloud", "/home/vagrant/.config/gcloud"
    control.vm.synced_folder "configure", "/home/vagrant/configure"
    control.vm.synced_folder "infrastructure", "/home/vagrant/infrastructure"
    control.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end

    control.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
    end
  end
end
