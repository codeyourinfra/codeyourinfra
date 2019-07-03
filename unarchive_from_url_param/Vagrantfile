# -*- mode: ruby -*-
# vi: set ft=ruby :

load '../common/timestamp-appender.rb'

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  (1..2).each do |i|
    config.vm.define "server#{i}" do |server|
      server.vm.hostname = "server#{i}"
      server.vm.network "private_network", ip: "192.168.33.#{i}0"
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
  end
end
