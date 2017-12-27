# Check log files in a server through the web browser

This solution is explained in detail in the Codeyourinfra project blog post [How to check log files in a server without logging in the server](http://codeyourinfra.today/how-to-check-log-files-in-a-server-without-logging-in-the-server). Check it out!

## Problem

The developers are always asking you the applications' log files, for troubleshooting purposes. The company's security policies determine that they can't log in the server where the files are. You're tired of sending the files by email to the developers all day long.

## Solution

Make the log files available through the web browser! The [playbook-jenkins-logs.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/check_server_log_files/playbook-jenkins-logs.yml) is an example of Ansible playbook which makes that for you. When executed, the playbook installs and configures the [Apache HTTP Server](https://httpd.apache.org) in a way that the Jenkins log files become accessible through the browser. The playbook can be easily adapted to make the same for any application you wish.

## Test

First of all, run the command `$ vagrant up`, in order to turn on the **jenkins server**. After that, execute the command `$ ansible-playbook playbook-jenkins-logs.yml -u vagrant -k -i hosts`, and type the **SSH password** *vagrant*. Finally, open your web browser and access the Jenkins log files through the **URL** http://192.168.33.10/logs/jenkins.

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
Java | Oracle JDK 1.8.0_151
Jenkins | 2.73.3
Apache | 2.4.7 (Ubuntu)

In addition, the test requires Internet connection, for the **minimal/trusty64** Vagrant box downloading. Depending on the Internet connection speed, the test environment can last more than you expect to be up and running, specially in the first time.

### Provisioning options

Since the [release 1.4.0](https://github.com/esign-consulting/codeyourinfra/tree/1.4.0), the Codeyourinfra project has been providing two options for provisioning: **baked** and **fried** (default). If the **jenkins server** is turned on with the **PROVISIONING_OPTION** environment variable set to **baked**, the Vagrant box that will be used is **codeyourinfra/jenkins**, instead of the default **minimal/trusty64**.

The tools used by the solution have already been installed in the **codeyourinfra/jenkins** Vagrant box, so it's needless to provision it from the scratch, like the **minimal/trusty64** Vagrant box requires. Despite the fact the **codeyourinfra/jenkins** Vagrant box is bigger than the **minimal/trusty64** Vagrant box, and it takes longer to download, it is much faster to boot up, as shown by the comparison table below:

PROVISIONING_OPTION | Vagrant box | Size (Mb) | Boot up duration (min)
------------------- | ----------- | --------- | ----------------------
fried (default) | [minimal/trusty64](https://app.vagrantup.com/minimal/boxes/trusty64/versions/14.04.3) | 271 | 8
baked | [codeyourinfra/jenkins](https://app.vagrantup.com/codeyourinfra/boxes/jenkins/versions/1.0) | 752 | 1

In order to check the durations, set the **APPEND_TIMESTAMP** environment variable to **true**. Then turn on the **jenkins server** twice, each time with a provisoning option. You will be able to follow how long the boot up takes through the `$ vagrant up` command output.

More details you can find in the Codeyourinfra project blog post [Choosing between baked and fried provisioning](http://codeyourinfra.today/choosing-between-baked-and-fried-provisioning).
