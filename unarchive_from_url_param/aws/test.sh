#!/bin/sh
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ ../*retry *.retry "$tmpfile" ec2_hosts params.json
}

. ../../common/test-library.sh

# check the repo server provisioning playbook syntax
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	checkPlaybookSyntax ../playbook-repo.yml ec2_hosts_template
fi

# turn on the environment
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
if [ ! -f ec2_hosts ]; then
	echo "Could not generate the inventory file."
	teardown
	exit 1
fi

# check the parameters file generation playbook syntax
checkPlaybookSyntax playbook-params-json.yml

# update the parameters file
rm -f params.json
ansible-playbook playbook-params-json.yml
if [ ! -f params.json ]; then
	echo "Could not update the parameters file."
	teardown
	exit 1
fi

# check the solution playbook syntax
checkPlaybookSyntax ../playbook-servers.yml ec2_hosts

# execute the solution
ansible-playbook ../playbook-servers.yml -i ec2_hosts -e "params_file=aws/params.json" | tee -a ${tmpfile}
assertEquals 2 $(tail -4 ${tmpfile} | grep -c "failed=0")

# validate the solution
ansible servers -i ec2_hosts -m shell -a "ls /var/target" | tee ${tmpfile}
assertEquals "apache-maven-3.5.0" $(awk '/server1/ {getline; print $0}' ${tmpfile})
assertEquals "apache-ant-1.10.1" $(awk '/server2/ {getline; print $0}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0