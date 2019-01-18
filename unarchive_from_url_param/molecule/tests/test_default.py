import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_apache2_is_installed(host):
    apache2 = host.package("apache2")
    assert apache2.is_installed
    assert apache2.version.startswith("2.")
