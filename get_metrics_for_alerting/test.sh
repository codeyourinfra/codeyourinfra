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
checkPlaybookSyntax playbook-add-server.yml

# execute the solution
ansible-playbook playbook-add-server.yml -e "host=192.168.33.20 user=vagrant private_key=.vagrant/machines/server1/virtualbox/private_key" | tee ${tmpfile}
assertEquals 1 $(tail -12 ${tmpfile} | grep -c "failed=0")
ansible-playbook playbook-add-server.yml -e "host=192.168.33.30 user=vagrant private_key=.vagrant/machines/server2/virtualbox/private_key" | tee ${tmpfile}
assertEquals 1 $(tail -12 ${tmpfile} | grep -c "failed=0")

# validate the solution
echo "Waiting 1 minute..."
sleep 60
ansible monitor -m shell -a "cat /etc/ansible/playbooks/playbook-get-metrics.log" | tee ${tmpfile}
assertEquals 3 $(tail -5 ${tmpfile} | grep -c "failed=0")

# turn off the environment and exit
teardown
exit 0