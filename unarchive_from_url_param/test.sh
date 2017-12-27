#!/bin/sh

# check the repo server provisioning
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	ansible-playbook playbook-repo.yml -i hosts --syntax-check
	if [ $? -ne 0 ]; then
		echo "Syntax error in playbook-repo.yml."
		exit 1
	fi
fi

# turn on the environment
vagrant up

# check and execute the solution
ansible-playbook playbook-servers.yml -i hosts

# validate the solution
ansible servers -i hosts -m shell -a "ls /var/target"

# turn off the environment
vagrant destroy -f
rm -rf .vagrant/
