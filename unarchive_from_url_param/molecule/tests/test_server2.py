import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server2')


def test_ant_dir_exists(host):
    ant_dir = host.file("/var/target/apache-ant-1.10.1")
    assert ant_dir.exists
    assert ant_dir.is_directory
