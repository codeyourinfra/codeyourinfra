import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server1')


def test_maven_dir_exists(host):
    maven_dir = host.file("/var/target/apache-maven-3.5.0")
    assert maven_dir.exists
    assert maven_dir.is_directory
