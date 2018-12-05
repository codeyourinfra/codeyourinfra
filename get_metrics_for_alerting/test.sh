#!/bin/bash
tmpfile=$(mktemp)

teardown()
{
	vagrant destroy -f
	rm -rf .vagrant/ *.retry "$tmpfile" ubuntu-*-cloudimg-console.log
}

. ../common/test-library.sh

# check the monitoring server provisioning playbook syntax
checkPlaybookSyntax playbook-monitor.yml hosts

# check the playbook-get-metrics.yml syntax
checkPlaybookSyntax playbook-get-metrics.yml monitored_hosts

# turn on the environment
vagrant up

# check the solution playbook syntax
checkPlaybookSyntax playbook-add-server.yml hosts

# execute the solution
ansible-playbook playbook-add-server.yml -i hosts -e "host=192.168.33.20 user=vagrant private_key=.vagrant/machines/server1/virtualbox/private_key" | tee ${tmpfile}
assertEquals 1 $(tail -10 ${tmpfile} | grep -c "failed=0")
ansible-playbook playbook-add-server.yml -i hosts -e "host=192.168.33.30 user=vagrant private_key=.vagrant/machines/server2/virtualbox/private_key" | tee ${tmpfile}
assertEquals 1 $(tail -10 ${tmpfile} | grep -c "failed=0")

# validate the solution
echo "Waiting 1 minute..."
sleep 60
ansible monitor -i hosts -m shell -a "cat /etc/ansible/playbooks/playbook-get-metrics.log" | tee ${tmpfile}
assertEquals 3 $(tail -5 ${tmpfile} | grep -c "failed=0")

# turn off the environment and exit
teardown
exit 0