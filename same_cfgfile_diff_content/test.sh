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
assertEquals 3 $(tail -10 ${tmpfile} | grep -c "failed=0")

# validate the solution
ansible qa -m shell -a "cat /etc/conf" | tee ${tmpfile}
assertEquals "prop1=Aprop2=B" $(awk '/qa1/ {for(i=1; i<=2; i++) {getline; printf $0}}' ${tmpfile})
assertEquals "prop1=Cprop2=D" $(awk '/qa2/ {for(i=1; i<=2; i++) {getline; printf $0}}' ${tmpfile})
assertEquals "prop1=Eprop2=F" $(awk '/qa3/ {for(i=1; i<=2; i++) {getline; printf $0}}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0