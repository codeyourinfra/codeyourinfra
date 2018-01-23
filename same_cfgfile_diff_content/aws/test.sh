#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ ../*retry *.retry "$tmpfile" ec2_hosts config.json
}

. ../../common/test-library.sh

# turn on the environment
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
assertFileExists ec2_hosts

# check the configuration file generation playbook syntax
checkPlaybookSyntax playbook-config-json.yml

# update the configuration file
rm -f config.json
ansible-playbook playbook-config-json.yml
assertFileExists config.json

# check the solution playbook syntax
checkPlaybookSyntax ../playbook.yml ec2_hosts

# execute the solution
ansible-playbook ../playbook.yml -i ec2_hosts -e "config_file=aws/config.json" | tee -a ${tmpfile}
assertEquals 3 $(tail -5 ${tmpfile} | grep -c "failed=0")

# validate the solution
ansible qa -i ec2_hosts -m shell -a "cat /etc/conf" | tee ${tmpfile}
assertEquals "prop1=Aprop2=B" $(awk '/qa1/ {for(i=1; i<=2; i++) {getline; printf}}' ${tmpfile})
assertEquals "prop1=Cprop2=D" $(awk '/qa2/ {for(i=1; i<=2; i++) {getline; printf}}' ${tmpfile})
assertEquals "prop1=Eprop2=F" $(awk '/qa3/ {for(i=1; i<=2; i++) {getline; printf}}' ${tmpfile})

# turn off the environment and exit
teardown
exit 0