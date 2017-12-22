#!/bin/sh

export APPEND_TIMESTAMP=true
export PROVISIONING_OPTION=baked

# turn on the environment
vagrant up

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
if [ ! -f ec2_hosts ]; then
	echo "Could not generate the inventory file."
	exit 1
fi

# update the parameters file
rm -f params.json
ansible-playbook playbook-params-json.yml
if [ ! -f params.json ]; then
	echo "Could not update the parameters file."
	exit 1
fi

# execute the solution
ansible-playbook ../playbook-servers.yml -i ec2_hosts -e "params_file=aws/params.json"

# validate the solution
ansible servers -i ec2_hosts -m shell -a "ls /var/target"

# turn off the environment and exit
vagrant destroy -f
rm -rf .vagrant/ ec2_hosts params.json
exit 0