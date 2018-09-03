#!/bin/bash
tmpfile=$(mktemp)

export ANSIBLE_FORCE_COLOR=true

if [[ "x$AWS_DEFAULT_REGION" == "x" ]]; then
	export AWS_DEFAULT_REGION=$(test -f ~/.aws/config && grep region ~/.aws/config | sed 's/.*=\s*//' || echo sa-east-1)
fi

# setup the aws region
ansible-playbook playbook-aws-region-configuration.yml -e aws_region=$AWS_DEFAULT_REGION

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" $AWS_DEFAULT_REGION/ec2_hosts $AWS_DEFAULT_REGION/codeyourinfra-aws-key-*.pem
}

. ../../common/test-library.sh

# install vagrant-aws plugin, if needed, and turn on the environment
if [ $(vagrant plugin list | grep -c vagrant-aws) -ne 1 ]; then
	vagrant plugin install vagrant-aws
fi
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f $AWS_DEFAULT_REGION/ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml -e aws_region=$AWS_DEFAULT_REGION
assertFileExists $AWS_DEFAULT_REGION/ec2_hosts

# check connectivity
ansible ec2_instances -i $AWS_DEFAULT_REGION/ec2_hosts -m ping | tee ${tmpfile}
assertEquals 3 $(grep -c '"ping": "pong"' ${tmpfile})

# turn off the environment and exit
teardown
exit 0