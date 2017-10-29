# Same configuration file with different content in different environments

This solution is explained in detail in the Codeyourinfra project blog post [How to deal with the same configuration file with different content in different environments](http://codeyourinfra.today/how-to-deal-with-the-same-configuration-file-with-different-content-in-different-environments). Check it out!

## Problem

The dev team has to deploy the application in different QA environments. The application requires a properties file where the database string connection is defined. In each environment the database string connection is different. This is just an example of the same configuration file with different content in different environments.

## Solution

Instead of having a version of the same configuration file for each environment, it's possible to mantain just one, including all the values required in every environment ([config.json](https://github.com/esign-consulting/codeyourinfra/blob/master/same_cfgfile_diff_content/config.json)). This metadata is then used during the single Ansible playbook's execution ([playbook.yml](https://github.com/esign-consulting/codeyourinfra/blob/master/same_cfgfile_diff_content/playbook.yml)) that sets the configuration file's content, specific to each environment. 

## Test

First of all, turn on the 3 VMs that represent the QA environments, executing the command `$ vagrant up`. After that, execute the command `$ ansible-playbook playbook.yml -u vagrant -k -i hosts`, and type *vagrant* for the **SSH password** prompted. Finally, in order to check the configuration file's content of every environment, execute the command `$ ansible qa -m shell -a "cat /etc/conf" -u vagrant -k -i hosts`.

### Important


Software | Version
--- | -----
Host OS | OS X El Capitan 10.11.6
VMs OS | Ubuntu 14.04.3 LTS
Vagrant | 2.0.0
VirtualBox | 5.1.30
VirtualBox Extension Pack | 5.1.28
Ansible | 2.4.0.0
