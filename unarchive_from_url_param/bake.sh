#!/bin/bash

teardown()
{
	vagrant destroy repo -f
	rm -rf .vagrant/ ubuntu-xenial-16.04-cloudimg-console.log
}

# turn on the repo server
vagrant up repo

# free up disk space
ansible repo -i hosts -m shell -a "apt-get clean && dd if=/dev/zero of=/EMPTY bs=1M && rm -f /EMPTY && cat /dev/null > ~/.bash_history && history -c && exit" -b

# bake the repo server
vagrant package repo -–output repo.box

# turn off the repo server and exit
teardown
exit 0