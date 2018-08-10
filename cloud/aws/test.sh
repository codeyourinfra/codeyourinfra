#!/bin/bash
tmpfile=$(mktemp)

if [[ "x$AWS_REGION" == "x" ]]; then
	export AWS_REGION=$(test -f ~/.aws/config && grep region ~/.aws/config | sed 's/.*=\s*//' || sa-east-1)
fi

# setup the aws region, if needed
if [ ! -d "$AWS_REGION" ]; then
	ansible-playbook playbook-aws-region-configuration.yml -e aws_region=$AWS_REGION
fi

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" $AWS_REGION/ec2_hosts
}

. ../../common/test-library.sh

# install vagrant-aws plugin, if needed, and turn on the environment
if [ $(vagrant plugin list | grep -c vagrant-aws) -ne 1 ]; then
	vagrant plugin install vagrant-aws
fi
AWS_DEFAULT_REGION=$AWS_REGION vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f $AWS_REGION/ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml -e aws_region=$AWS_REGION
assertFileExists $AWS_REGION/ec2_hosts

# check connectivity
ansible ec2_instances -i $AWS_REGION/ec2_hosts -m ping | tee ${tmpfile}
assertEquals 3 $(grep -c '"ping": "pong"' ${tmpfile})

# turn off the environment and exit
teardown
exit 0