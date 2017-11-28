# Unarchive different remote files in different target servers

This solution is explained in detail in the Codeyourinfra project blog post [How to unarchive different files in different servers in just one shot](http://codeyourinfra.today/how-to-unarchive-different-files-in-different-servers-in-just-one-shot). Check it out!

## Problem

You have a bunch of servers and quite often you have to manually extract in each one a specific compressed file. It works well when there's not too many servers to change, but such task becomes really boring and even error-prone when it reaches, say, a hundred servers or more. How can it be done in scale?

## Solution

Keep in a separated file all the information needed ([params.json](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/params.json)). For each server, inform where the compressed file is (**url**) and where it must be extracted in (**target** directory). These parameters will be used during the Ansible playbook's execution ([playbook-servers.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/playbook-servers.yml)). All the servers listed in the Ansible inventory ([hosts](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/hosts)) file's **servers** section will be affected in a single execution.

## Test

First of all, turn on the VMs, executing the command `$ vagrant up`. The VM from which the compressed files will be downloaded (**repo server**) is automatically provisioned ([playbook-repo.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/unarchive_from_url_param/playbook-repo.yml)). The others VMs (**server1** and **server2**) represent the set of target servers where the unarchive task will be performed.

Once the test environment is up, execute the command `$ ansible-playbook playbook-servers.yml -u vagrant -k -i hosts`. The **-u** parameter identifies the SSH user, the **-k** parameter prompts for password information (vagrant, too), and the **-i** parameter points to the inventory file. In just one shot, the task is automatically performed server by server.

### Important

The test was done in the environment described in the table below.

Software | Version
--- | -----
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
VirtualBox | 5.1.30
VirtualBox Extension Pack | 5.1.28
Ansible | 2.4.0.0
Apache | 2.4.7 (Ubuntu)

In addition, the test requires Internet connection, for the **minimal/trusty64** Vagrant box downloading and for the **repo** VM provisioning. Depending on the Internet connection speed, the whole test environment can last more than you expect to be up and running.

If you are behind a proxy, extra configuration is needed. Make sure you can access the [Ubuntu remote repository](http://us.archive.ubuntu.com) and you are able to download compressed files.

### Provisioning options

Since [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/tree/1.4.0), the Codeyourinfra project provides two options for provisioning: **baked** and **fried** (default). If the **repo server** is turned on with the **PROVISIONING_OPTION** environment variable set to **baked**, the Vagrant box that will be used is **codeyourinfra/repo**, instead of the default **minimal/trusty64**.

Apache HTTP Server has already been installed in the **codeyourinfra/repo** Vagrant box, so it's needless to provision it from the scratch, like the **minimal/trusty64** Vagrant box requires. Booting up the **repo server** with the **codeyourinfra/repo** Vagrant box is faster, as shown by the comparison table below:

PROVISIONING_OPTION | Vagrant box | Size (Mb) | Boot up duration (min)
------------------- | ----------- | --------- | ----------------------
fried (default) | [minimal/trusty64](https://app.vagrantup.com/minimal/boxes/trusty64/versions/14.04.3) | 271 | 2
baked | [codeyourinfra/repo](https://app.vagrantup.com/codeyourinfra/boxes/repo/versions/1.0) | 259 | 0.5

In order to check the durations, set the **APPEND_TIMESTAMP** environment variable to **true**. Then turn on the **repo server** twice, each time with a provisoning option. You will be able to follow how long the boot up takes through the `$ vagrant up repo` command output. More details you can find in the Codeyourinfra project blog post []().
