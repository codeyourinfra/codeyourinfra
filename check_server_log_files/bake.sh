#!/bin/bash

teardown()
{
	vagrant destroy jenkins -f
	rm -rf .vagrant/ ubuntu-xenial-16.04-cloudimg-console.log
}

# turn on the jenkins server
vagrant up jenkins

# show information about the jenkins server
ansible jenkins -i hosts -m shell -a "java -version"
ansible jenkins -i hosts -m shell -a "java -jar /usr/share/jenkins/jenkins.war --version"

# bake the jenkins server
vagrant package jenkins --output jenkins.box

# turn off the jenkins server and exit
teardown
exit 0
