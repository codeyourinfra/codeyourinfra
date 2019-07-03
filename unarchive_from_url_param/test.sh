#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" ubuntu-*-cloudimg-console.log
}

. ../common/test-library.sh

# turn on the environment
vagrant up

# check the solution playbook syntax
checkPlaybookSyntax playbook.yml

# execute the solution
ansible-playbook playbook.yml | tee ${tmpfile}
assertEquals 2 $(tail -10 ${tmpfile} | grep -c "failed=0")

# validate the solution
ansible servers -m shell -a "ls /opt" | tee ${tmpfile}
assertEquals "apache-maven-3.5.0" $(awk '/server1/ {getline; print $0}' ${tmpfile})
assertEquals "apache-ant-1.10.1" $(awk '/server2/ {getline; print $0}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0