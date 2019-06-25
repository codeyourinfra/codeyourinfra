import os
import re
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_java8_is_installed(host):
    java8 = host.package("openjdk-8-jdk")
    assert java8.is_installed
    assert java8.version.startswith("8u")


def test_jenkins_is_installed(host):
    cmd = host.run("java -jar /usr/share/jenkins/jenkins.war --version")
    assert cmd.rc == 0
    pattern = re.compile("^[\\d.]+$")
    assert pattern.match(cmd.stdout)


def test_apache2_is_installed(host):
    apache2 = host.package("apache2")
    assert apache2.is_installed
    assert apache2.version.startswith("2.")


def test_jenkins_log_file_download(host):
    cmd = host.run("wget http://localhost/logs/jenkins/jenkins.log")
    assert cmd.rc == 0
    jenkins_log_file = host.file("jenkins.log")
    assert jenkins_log_file.exists
    assert jenkins_log_file.contains("INFO: Jenkins is fully up and running")
