#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ ../*retry *.retry "$tmpfile" ec2_hosts codeyourinfra-aws-key.pem
}

. ../../common/test-library.sh

# check the monitoring server provisioning playbook syntax
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	checkPlaybookSyntax ../playbook-monitor.yml ec2_hosts_template
fi

# check the playbook-get-metrics.yml syntax
checkPlaybookSyntax ../playbook-get-metrics.yml ../monitored_hosts

# turn on the environment
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
assertFileExists ec2_hosts

# check the solution playbook syntax
checkPlaybookSyntax ../playbook-add-server.yml ec2_hosts

# execute the solution
cp ../../cloud/aws/sa-east-1/codeyourinfra-aws-key.pem .
SERVER1_IP=$(awk '/server1/ {split($2,a,"="); print a[2]}' ec2_hosts)
ansible-playbook ../playbook-add-server.yml -i ec2_hosts -e "host=${SERVER1_IP} user=ubuntu private_key=aws/codeyourinfra-aws-key.pem" | tee ${tmpfile}
assertEquals 1 $(tail -3 ${tmpfile} | grep -c "failed=0")
SERVER2_IP=$(awk '/server2/ {split($2,a,"="); print a[2]}' ec2_hosts)
ansible-playbook ../playbook-add-server.yml -i ec2_hosts -e "host=${SERVER2_IP} user=ubuntu private_key=aws/codeyourinfra-aws-key.pem" | tee ${tmpfile}
assertEquals 1 $(tail -3 ${tmpfile} | grep -c "failed=0")

# validate the solution
echo "Waiting 1 minute..."
sleep 60
ansible monitor -i ec2_hosts -m shell -a "cat /etc/ansible/playbooks/playbook-get-metrics.log" | tee ${tmpfile}
assertEquals 3 $(tail -5 ${tmpfile} | grep -c "failed=0")

# turn off the environment and exit
teardown
exit 0