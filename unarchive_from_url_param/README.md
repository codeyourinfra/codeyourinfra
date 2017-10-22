# Unarchive different remote files in different target servers

## Problem

You have a bunch of servers and quite often you have to manually extract in each one a specific compressed file. It works well when there's not too many servers to change, but such task becomes really boring and even error-prone when it reaches, say, a hundred servers or more.

## Solution

Keep in a separated file all the information needed ([params.json](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/params.json)). For each server, inform where the compressed file is (url) and where it must be extracted in (target directory). These parameters will be used during the Ansible playbook execution ([playbook-servers.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/playbook-servers.yml)). All the servers listed in the Ansible inventory file ([hosts](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/hosts)) **servers** section will be affected in a single execution.

## Test environment

Key | Value
--- | -----
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
Virtual Box | 5.1.30
Ansible | 2.4.0.0
