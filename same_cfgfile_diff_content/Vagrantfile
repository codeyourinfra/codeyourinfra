# -*- mode: ruby -*-
# vi: set ft=ruby :

load '../common/timestamp-appender.rb'

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  (1..3).each do |i|
    config.vm.define "qa#{i}" do |qa|
      qa.vm.hostname = "qa#{i}"
      qa.vm.network "private_network", ip: "192.168.33.#{i}0"
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
  end
end
