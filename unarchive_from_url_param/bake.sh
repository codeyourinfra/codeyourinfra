#!/bin/bash

teardown()
{
	vagrant destroy repo -f
	rm -rf .vagrant/ ubuntu-xenial-16.04-cloudimg-console.log
}

# turn on the repo server
vagrant up repo

# show information about the repo server
ansible repo -i hosts -m shell -a "lsb_release -a"
ansible repo -i hosts -m shell -a "apache2 -v"

# bake the repo server
vagrant package repo --output repo.box

# turn off the repo server and exit
teardown
exit 0
