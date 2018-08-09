#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" sa-east-1/ec2_hosts
}

. ../../common/test-library.sh

# turn on the environment
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f sa-east-1/ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml -e "aws_region=sa-east-1"
assertFileExists sa-east-1/ec2_hosts

# check connectivity
ansible ec2_instances -i sa-east-1/ec2_hosts -m ping | tee ${tmpfile}
assertEquals 3 $(grep -c '"ping": "pong"' ${tmpfile})

# turn off the environment and exit
teardown
exit 0