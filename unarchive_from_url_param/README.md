# Unarchive different remote files in different target servers

## Problem

You have a bunch of servers and quite often you have to manually extract in each one a specific compressed file. It works well when there's not too many servers to change, but such task becomes really boring and even error-prone when it reaches, say, a hundred servers or more. How can it be done in scale?

## Solution

Keep in a separated file all the information needed ([params.json](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/params.json)). For each server, inform where the compressed file is (**url**) and where it must be extracted in (**target** directory). These parameters will be used during the Ansible playbook's execution ([playbook-servers.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/playbook-servers.yml)). All the servers listed in the Ansible inventory ([hosts](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/hosts)) file's **servers** section will be affected in a single execution.

## Test

First of all, turn on the VMs, executing the command `$ vagrant up`. The VM from which the compressed files will be downloaded (**repo**) is automatically provisioned ([playbook-repo.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/playbook-repo.yml)). The others VMs (**server1** and **server2**) represent the set of target servers where the unarchive task will be performed.

Once the test environment is up, execute the command `$ ansible-playbook playbook-servers.yml -u vagrant -k -i hosts`. The **-u** parameter identifies the ssh user, the **-k** parameter prompts for password information (vagrant, too), and the **-i** parameter points to the inventory file. In just one shot, the task is automatically performed server by server.


Software | Version
--- | -----
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
Virtual Box | 5.1.30
Ansible | 2.4.0.0
