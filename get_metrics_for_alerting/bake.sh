#!/bin/bash

teardown()
{
	vagrant destroy monitor -f
	rm -rf .vagrant/ ubuntu-xenial-16.04-cloudimg-console.log
}

# turn on the monitor server
vagrant up monitor

# show information about the monitor server
ansible monitor -i hosts -m shell -a "/usr/bin/influxd version"
ansible monitor -i hosts -m shell -a "curl -s localhost:3000/login | grep span warn=no"
ansible monitor -i hosts -m shell -a "ansible --version"

# bake the monitor server
vagrant package monitor --output monitor.box

# turn off the monitor server and exit
teardown
exit 0
