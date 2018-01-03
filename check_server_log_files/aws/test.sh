#!/bin/sh
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ ../*retry *.retry "$tmpfile" ec2_hosts jenkins.log
}

. ../../common/test-library.sh

# check the jenkins server provisioning playbook syntax
if [[ ! -n $PROVISIONING_OPTION || "$PROVISIONING_OPTION" = "fried" ]]; then
	checkPlaybookSyntax ../playbook-jenkins.yml ec2_hosts_template
fi

# turn on the environment
vagrant up

# check the inventory generation playbook syntax
checkPlaybookSyntax playbook-ec2-instances-inventory.yml

# generate the inventory
rm -f ec2_hosts
ansible-playbook playbook-ec2-instances-inventory.yml
assertFileExists ec2_hosts

# check the solution playbook syntax
checkPlaybookSyntax ../playbook-jenkins-logs.yml ec2_hosts

# execute the solution
ansible-playbook ../playbook-jenkins-logs.yml -i ec2_hosts | tee -a ${tmpfile}
assertEquals 1 $(tail -3 ${tmpfile} | grep -c "failed=0")

# validate the solution
JENKINS_SERVER_IP=$(awk '/\[jenkins\]/ {getline; print $0}' ec2_hosts)
wget http://${JENKINS_SERVER_IP}/logs/jenkins/jenkins.log
if [ $? -ne 0 ]; then
	echo "Error on jenkins.log download"
	teardown
	exit 1
fi
assertFileExists jenkins.log
assertEquals 1 $(grep -c "INFO: Jenkins is fully up and running" jenkins.log)

# turn off the environment and exit
teardown
exit 0