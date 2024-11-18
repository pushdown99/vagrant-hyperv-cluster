# -*- mode: ruby -*-
# vi: set ft=ruby :

box = "boxen/ubuntu-22.04"
ver = "2024.07.24.10"
num = 2
ip = '192.168.0.10'
broad = '192.168.0.255'
port = 1003
master = "k8s-m"
worker = "k8s-w"
cni = "flannel" # flannel | calico
token  = "123456.1234567890123456"
pod = "10.244.10.0/24"
mip = "#{ip}0"

Vagrant.configure("2") do |config|
  hosts = ""
  
  hosts += ["#{ip}0", "#{master}"].join(',')
  (1..num).each do |n|
    hosts += '|' + ["#{ip}#{n}", "#{worker}#{n}"].join(',')
  end

  config.vm.define master do |c|
    c.vm.box=box
    c.vm.box_version = ver
    c.vm.provider :hyperv do |v|
      v.vmname=master
      v.cpus=2
      v.memory=2048
      v.linked_clone=true
    end

    c.vm.hostname=master
    c.vm.synced_folder ".", "/vagrant", disabled: true
    c.vm.network "forwarded_port", guest: 22, host: "#{port}0", auto_correct: true, id: "ssh"
    c.vm.provision 'shell', path: "bootstrap.sh", args: ["#{ip}0", "#{broad}", "#{hosts}"]     
    c.vm.provision 'shell', path: "k8s-master.sh", args: ["#{token}", "#{mip}", "#{pod}", "#{cni}"]
  end

  (1..num).each do |n|
    config.vm.define "#{worker}#{n}" do |c|
      c.vm.box=box
      c.vm.provider :hyperv do |v|
        v.vmname="#{worker}#{n}"
        v.cpus=1
        v.memory=1024
        v.linked_clone=true
      end

      c.vm.hostname="#{worker}#{n}"
      c.vm.synced_folder ".", "/vagrant", disabled: true
      c.vm.network "forwarded_port", guest: 22, host: "#{port}#{n}", auto_correct: true, id: "ssh"
      c.vm.provision 'shell', path: "bootstrap.sh", args: ["#{ip}#{n}", "#{broad}", "#{hosts}"]
      c.vm.provision 'shell', path: "k8s-worker.sh", args: ["#{ip}0", "#{token}"]
    end
  end
end