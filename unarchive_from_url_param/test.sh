#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" ubuntu-xenial-16.04-cloudimg-console.log
}

. ../common/test-library.sh

# check the repo server provisioning playbook syntax
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	checkPlaybookSyntax playbook-repo.yml hosts
fi

# turn on the environment
vagrant up

# check the solution playbook syntax
checkPlaybookSyntax playbook-servers.yml hosts

# execute the solution
ansible-playbook playbook-servers.yml -i hosts | tee ${tmpfile}
assertEquals 2 $(tail -4 ${tmpfile} | grep -c "failed=0")

# validate the solution
ansible servers -i hosts -m shell -a "ls /var/target" | tee ${tmpfile}
assertEquals "apache-maven-3.5.0" $(awk '/server1/ {getline; print $0}' ${tmpfile})
assertEquals "apache-ant-1.10.1" $(awk '/server2/ {getline; print $0}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0