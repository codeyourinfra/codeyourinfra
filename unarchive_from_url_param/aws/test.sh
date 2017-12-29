#!/bin/sh
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry ec2_hosts params.json "$tmpfile"
}

# check the repo server provisioning
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	ansible-playbook ../playbook-repo.yml -i ec2_hosts_template --syntax-check
	if [ $? -ne 0 ]; then
		echo "Syntax error in playbook-repo.yml."
		exit 1
	fi
fi

# turn on the environment
vagrant up

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
if [ ! -f ec2_hosts ]; then
	echo "Could not generate the inventory file."
	teardown
	exit 1
fi

# update the parameters file
rm -f params.json
ansible-playbook playbook-params-json.yml
if [ ! -f params.json ]; then
	echo "Could not update the parameters file."
	teardown
	exit 1
fi

# execute the solution
ansible-playbook ../playbook-servers.yml -i ec2_hosts -e "params_file=aws/params.json" | tee -a ${tmpfile}
success=$(tail -4 ${tmpfile} | grep -c "failed=0")
if [ ${success} -ne 2 ]; then
	echo "Error on playbook-servers.yml execution."
	teardown
	exit 1
fi

# validate the solution
ansible servers -i ec2_hosts -m shell -a "ls /var/target" | tee ${tmpfile}
assert1=$(awk '/server1/ {getline; print $0}' ${tmpfile})
assert2=$(awk '/server2/ {getline; print $0}' ${tmpfile})
if [[ ${assert1} != "apache-maven-3.5.0" || ${assert2} != "apache-ant-1.10.1" ]]; then
	echo "Assertion error."
	teardown
	exit 1
fi

# turn off the environment and exit
teardown
exit 0