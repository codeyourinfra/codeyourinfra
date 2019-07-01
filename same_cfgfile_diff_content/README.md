# Same configuration file with different content in different environments

This solution is explained in detail in the Codeyourinfra project blog post [How to deal with the same configuration file with different content in different environments](http://codeyourinfra.today/how-to-deal-with-the-same-configuration-file-with-different-content-in-different-environments). Check it out!

## Problem

The dev team has to deploy the application in different QA environments. The application requires a properties file where the database string connection is defined. In each environment the database string connection is different. This is just an example of the same configuration file with different content in different environments.

## Solution

Instead of having a version of the same configuration file for each environment, it's possible to maintain just one, including all the values required in every environment ([config.json](config.json)). This metadata is then used during the single Ansible playbook's execution ([playbook.yml](playbook.yml)) that sets the configuration file's content, specific to each environment. 

## Test

First of all, turn on the 3 VMs that represent the QA environments, executing the command `$ vagrant up`. After that, execute the command `$ ansible-playbook playbook.yml`. Finally, in order to check the configuration file's content of every environment, execute the command `$ ansible qa -m shell -a "cat /etc/conf"`.

If you prefer to test automatically, just run `$ ./test.sh`. Likewise, if you prefer to test against EC2 instances, rather than local VMs, just run `$ cd aws/ && ./test.sh`.

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

In addition, the test requires Internet connection, for the **minimal/trusty64** Vagrant box downloading. Depending on the Internet connection speed, the test environment can last more than you expect to be up and running, in the first time.
