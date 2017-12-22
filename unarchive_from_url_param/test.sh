#!/bin/sh

export APPEND_TIMESTAMP=true
export PROVISIONING_OPTION=baked

# turn on the environment
vagrant up

# execute the solution
ansible-playbook playbook-servers.yml -i hosts

# validate the solution
ansible servers -i hosts -m shell -a "ls /var/target"

# turn off the environment
vagrant destroy -f
rm -rf .vagrant/
