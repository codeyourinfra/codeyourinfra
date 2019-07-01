import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('qa')


def test_cfgfile_exists(host):
    cfgfile = host.file("/etc/conf")
    assert cfgfile.exists
    assert cfgfile.is_file
