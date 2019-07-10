import os
import time

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('monitor')


def test_log(host):
    time.sleep(60)
    log = host.file("/etc/ansible/playbooks/playbook-get-metrics.log")
    assert log.exists
    assert log.is_file
    assert log.contains("192.168.33.20              : ok=2")
    assert log.contains("192.168.33.30              : ok=2")
    assert log.contains("localhost                  : ok=2")
