#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" ubuntu-*-cloudimg-console.log jenkins.log
}

. ../common/test-library.sh

# turn on the environment
vagrant up

# check the solution playbook syntax
checkPlaybookSyntax playbook.yml

# execute the solution
ansible-playbook playbook.yml | tee ${tmpfile}
assertEquals 1 $(tail -10 ${tmpfile} | grep -c "failed=0")

# validate the solution
wget http://192.168.33.10/logs/jenkins/jenkins.log
if [ $? -ne 0 ]; then
	echo "Error on jenkins.log download"
	teardown
	exit 1
fi
assertFileExists jenkins.log
assertEquals 1 $(grep -c "INFO: Jenkins is fully up and running" -m 1 jenkins.log)

# turn off the environment and exit
teardown
exit 0