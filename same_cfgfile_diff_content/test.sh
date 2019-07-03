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
ansible qa -m shell -a "cat /etc/conn.properties" | tee ${tmpfile}
assertEquals "url=jdbc:mysql://db1/mydbusername=qa1userpassword=qa1secret" $(awk '/qa1/ {for(i=1; i<=3; i++) {getline; printf $0}}' ${tmpfile})
assertEquals "url=jdbc:mysql://db2/mydbusername=qa2userpassword=qa2secret" $(awk '/qa2/ {for(i=1; i<=3; i++) {getline; printf $0}}' ${tmpfile})
assertEquals "url=jdbc:mysql://db3/mydbusername=qa3userpassword=qa3secret" $(awk '/qa3/ {for(i=1; i<=3; i++) {getline; printf $0}}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0