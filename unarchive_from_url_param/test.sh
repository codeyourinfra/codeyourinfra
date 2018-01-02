#!/bin/sh
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile"
}

. ../common/test-library.sh

# check the repo server provisioning playbook syntax
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	playbookSyntaxCheck playbook-repo.yml hosts
	SYNTAX_CHECK_RC=$?
	if [ $SYNTAX_CHECK_RC -ne 0 ]; then
		exit 1
	fi
fi

# turn on the environment
vagrant up

# check the solution playbook syntax
playbookSyntaxCheck playbook-servers.yml hosts
SYNTAX_CHECK_RC=$?
if [ $SYNTAX_CHECK_RC -ne 0 ]; then
	teardown
	exit 1
fi

# execute the solution
ansible-playbook playbook-servers.yml -i hosts | tee ${tmpfile}
success=$(tail -4 ${tmpfile} | grep -c "failed=0")
if [ ${success} -ne 2 ]; then
	echo "Error on playbook-servers.yml execution."
	teardown
	exit 1
fi

# validate the solution
ansible servers -i hosts -m shell -a "ls /var/target" | tee ${tmpfile}
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