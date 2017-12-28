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

# execute the solution
tmpfile=$(mktemp)
ansible-playbook playbook-servers.yml -i hosts | tee -a ${tmpfile}
success=$(tail -4 ${tmpfile} | grep -c "failed=0")
if [ ${success} -ne 2 ]; then
	echo "Error on playbook-servers.yml execution."
	exit 1
fi

# validate the solution
ansible servers -i hosts -m shell -a "ls /var/target"

# turn off the environment
vagrant destroy -f
rm -rf .vagrant/ "$tmpfile"
