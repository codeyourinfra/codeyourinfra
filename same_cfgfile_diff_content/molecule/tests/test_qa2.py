import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('qa2')


def test_cfgfile_content(host):
    cfgfile = host.file("/etc/conf")
    assert cfgfile.contains("prop1=C")
    assert cfgfile.contains("prop2=D")
